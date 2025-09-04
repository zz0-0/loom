use regex::Regex;
use lazy_static::lazy_static;
use std::io::{BufRead, BufReader};
use std::fs::File;

use crate::blox::ast::{Document, Block, BlockType, Attribute};
use crate::blox::error::{BloxError, ParseResult};

lazy_static! {
    /// Matches block start lines: #{1,6} block_type attributes
    static ref BLOCK_START: Regex = Regex::new(
        r"^(#{1,6})\s*([a-zA-Z][a-zA-Z0-9_-]*)\s*(.*?)$"
    ).unwrap();
    
    /// Matches key=value attributes with quoted or unquoted values
    static ref ATTRIBUTE: Regex = Regex::new(
        r#"(\w+)=(?:"([^"]*)"|'([^']*)'|([^\s]+))"#
    ).unwrap();
    
    /// Matches positional attributes (quoted strings without key=)
    static ref POSITIONAL_ATTR: Regex = Regex::new(
        r#"(?:^|\s+)(?:"([^"]*)"|'([^']*)'|([^\s"'=]+))"#
    ).unwrap();
    
    /// Matches comment lines
    static ref COMMENT: Regex = Regex::new(
        r"^\s*//"
    ).unwrap();
    
    /// Matches inline elements {{type:content}}
    static ref INLINE: Regex = Regex::new(
        r"\{\{([^:}]+):([^}]*)\}\}"
    ).unwrap();
}

pub struct BloxParser {
    document: Document,
    block_stack: Vec<Block>,
    current_line: usize,
}

#[derive(Debug)]
enum LineType {
    BlockStart {
        level: usize,
        block_type: String,
        attributes_str: String,
    },
    Content(String),
    Comment,
    Empty,
}

impl BloxParser {
    pub fn new() -> Self {
        Self {
            document: Document::new(),
            block_stack: Vec::new(),
            current_line: 0,
        }
    }
    
    /// Parse a Blox document from a string
    pub fn parse_string(&mut self, content: &str) -> ParseResult<Document> {
        for (line_num, line) in content.lines().enumerate() {
            self.current_line = line_num + 1;
            self.parse_line(line)?;
        }
        
        self.finalize_document()
    }
    
    /// Parse a Blox document from a file
    pub fn parse_file(&mut self, file_path: &str) -> ParseResult<Document> {
        let file = File::open(file_path)?;
        let reader = BufReader::new(file);
        
        for (line_num, line_result) in reader.lines().enumerate() {
            self.current_line = line_num + 1;
            let line = line_result?;
            self.parse_line(&line)?;
        }
        
        self.finalize_document()
    }
    
    fn parse_line(&mut self, line: &str) -> ParseResult<()> {
        let line_type = self.classify_line(line);
        
        match line_type {
            LineType::BlockStart { level, block_type, attributes_str } => {
                self.handle_block_start(level, block_type, attributes_str)?;
            }
            LineType::Content(content) => {
                self.handle_content_line(content);
            }
            LineType::Comment | LineType::Empty => {
                // Ignore comments and empty lines
            }
        }
        
        Ok(())
    }
    
    fn classify_line(&self, line: &str) -> LineType {
        let trimmed = line.trim();
        
        // Empty line
        if trimmed.is_empty() {
            return LineType::Empty;
        }
        
        // Comment line
        if COMMENT.is_match(line) {
            return LineType::Comment;
        }
        
        // Block start line
        if let Some(captures) = BLOCK_START.captures(line) {
            let level = captures[1].len();
            let block_type = captures[2].to_string();
            let attributes_str = captures.get(3).map_or("", |m| m.as_str()).to_string();
            
            return LineType::BlockStart {
                level,
                block_type,
                attributes_str,
            };
        }
        
        // Content line
        LineType::Content(line.to_string())
    }
    
    fn handle_block_start(
        &mut self,
        level: usize,
        block_type: String,
        attributes_str: String,
    ) -> ParseResult<()> {
        // Close blocks at same or higher level
        self.close_blocks_at_level(level);
        
        // Create new block
        let block_type_enum = BlockType::from_str(&block_type);
        let mut block = Block::new(block_type_enum, level, self.current_line);
        
        // Parse attributes
        let attributes = self.parse_attributes(&attributes_str, &block_type)?;
        block.attributes = attributes;
        
        // Add block to stack
        self.block_stack.push(block);
        
        Ok(())
    }
    
    fn handle_content_line(&mut self, content: String) {
        if let Some(current_block) = self.block_stack.last_mut() {
            if !current_block.content.is_empty() {
                current_block.content.push('\n');
            }
            current_block.content.push_str(&content);
        } else {
            // Content without a block - create implicit paragraph
            let mut paragraph = Block::new(BlockType::Paragraph, 1, self.current_line);
            paragraph.content = content;
            self.block_stack.push(paragraph);
        }
    }
    
    fn parse_attributes(&self, attrs_str: &str, block_type: &str) -> ParseResult<Vec<Attribute>> {
        let mut attributes = Vec::new();
        let attrs_str = attrs_str.trim();
        
        if attrs_str.is_empty() {
            return Ok(attributes);
        }
        
        // First, try to parse key=value attributes
        for captures in ATTRIBUTE.captures_iter(attrs_str) {
            let key = captures[1].to_string();
            let value = captures.get(2)
                .or(captures.get(3))
                .or(captures.get(4))
                .map(|m| m.as_str())
                .unwrap_or("")
                .to_string();
            
            attributes.push(Attribute { key, value });
        }
        
        // Then handle positional attributes (shorthand)
        let remaining = ATTRIBUTE.replace_all(attrs_str, "");
        let positional_attrs: Vec<&str> = POSITIONAL_ATTR
            .captures_iter(&remaining)
            .filter_map(|caps| {
                caps.get(1).or(caps.get(2)).or(caps.get(3))
                    .map(|m| m.as_str())
            })
            .collect();
        
        // Apply positional attributes based on block type
        for (i, value) in positional_attrs.iter().enumerate() {
            let key = self.get_positional_key(block_type, i);
            attributes.push(Attribute {
                key: key.to_string(),
                value: value.to_string(),
            });
        }
        
        Ok(attributes)
    }
    
    fn get_positional_key(&self, block_type: &str, index: usize) -> &'static str {
        match (block_type, index) {
            ("section" | "h1" | "h2" | "h3" | "h4" | "h5" | "h6", 0) => "title",
            ("image" | "img", 0) => "src",
            ("image" | "img", 1) => "alt",
            ("code" | "c", 0) => "lang",
            ("quote" | "q", 0) => "author",
            ("table" | "tbl", 0) => "caption",
            _ => "value",
        }
    }
    
    fn close_blocks_at_level(&mut self, level: usize) {
        while let Some(last_block) = self.block_stack.last() {
            if last_block.level < level {
                break;
            }
            
            let completed_block = self.block_stack.pop().unwrap();
            
            if let Some(parent) = self.block_stack.last_mut() {
                parent.children.push(completed_block);
            } else {
                self.document.blocks.push(completed_block);
            }
        }
    }
    
    fn finalize_document(&mut self) -> ParseResult<Document> {
        // Close all remaining blocks
        self.close_blocks_at_level(0);
        
        Ok(self.document.clone())
    }
}

impl Default for BloxParser {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_simple_parsing() {
        let mut parser = BloxParser::new();
        let content = r#"
#h1 "Welcome to Blox"
This is the introduction.

#h2 "Features"
##code lang=rust
fn hello() {
    println!("Hello, Blox!");
}
"#;
        
        let doc = parser.parse_string(content).unwrap();
        assert_eq!(doc.blocks.len(), 2);
        assert_eq!(doc.blocks[0].level, 1);
        assert_eq!(doc.blocks[0].get_attribute("title"), Some("Welcome to Blox"));
    }
    
    #[test]
    fn test_attribute_parsing() {
        let mut parser = BloxParser::new();
        let content = r#"#img src="logo.png" alt="Logo" width=100"#;
        
        let doc = parser.parse_string(content).unwrap();
        let block = &doc.blocks[0];
        
        assert_eq!(block.get_attribute("src"), Some("logo.png"));
        assert_eq!(block.get_attribute("alt"), Some("Logo"));
        assert_eq!(block.get_attribute("width"), Some("100"));
    }
}
