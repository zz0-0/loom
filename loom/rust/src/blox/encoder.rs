use std::fmt::Write;
use crate::blox::ast::{Document, Block, BlockType, Attribute};
use crate::blox::error::ParseResult;

pub struct BloxEncoder {
    indent_size: usize,
    use_shorthand: bool,
}

impl BloxEncoder {
    pub fn new() -> Self {
        Self {
            indent_size: 0,
            use_shorthand: true,
        }
    }
    
    pub fn with_options(indent_size: usize, use_shorthand: bool) -> Self {
        Self {
            indent_size,
            use_shorthand,
        }
    }
    
    /// Encode a Document back to Blox format
    pub fn encode(&self, document: &Document) -> ParseResult<String> {
        let mut output = String::new();
        
        // Encode document metadata as comments
        if !document.metadata.is_empty() {
            writeln!(output, "// Document metadata").unwrap();
            for (key, value) in &document.metadata {
                writeln!(output, "// {}: {}", key, value).unwrap();
            }
            writeln!(output).unwrap();
        }
        
        // Encode all blocks
        for block in &document.blocks {
            self.encode_block(&mut output, block, 0)?;
        }
        
        Ok(output)
    }
    
    fn encode_block(&self, output: &mut String, block: &Block, parent_level: usize) -> ParseResult<()> {
        // Calculate indentation
        let indent = if self.indent_size > 0 {
            " ".repeat(parent_level * self.indent_size)
        } else {
            String::new()
        };
        
        // Generate block header
        let level_markers = "#".repeat(block.level);
        let block_type = self.get_block_type_string(&block.block_type);
        let attributes = self.encode_attributes(&block.attributes, &block.block_type);
        
        // Write block start line
        if attributes.is_empty() {
            writeln!(output, "{}{}{}", indent, level_markers, block_type).unwrap();
        } else {
            writeln!(output, "{}{}{} {}", indent, level_markers, block_type, attributes).unwrap();
        }
        
        // Write block content
        if !block.content.is_empty() {
            for line in block.content.lines() {
                writeln!(output, "{}{}", indent, line).unwrap();
            }
        }
        
        // Write children
        for child in &block.children {
            self.encode_block(output, child, parent_level + 1)?;
        }
        
        // Add blank line after block (except for last block)
        writeln!(output).unwrap();
        
        Ok(())
    }
    
    fn get_block_type_string(&self, block_type: &BlockType) -> String {
        if self.use_shorthand {
            // Use shorthand when available
            match block_type {
                BlockType::Section => "section".to_string(),
                BlockType::Paragraph => "p".to_string(),
                BlockType::Code => "c".to_string(),
                BlockType::Quote => "q".to_string(),
                BlockType::Image => "img".to_string(),
                BlockType::Table => "tbl".to_string(),
                BlockType::Math => "m".to_string(),
                _ => block_type.to_str().to_string(),
            }
        } else {
            // Use canonical form
            block_type.canonical().to_str().to_string()
        }
    }
    
    fn encode_attributes(&self, attributes: &[Attribute], block_type: &BlockType) -> String {
        if attributes.is_empty() {
            return String::new();
        }
        
        let mut parts = Vec::new();
        
        // Handle positional attributes first
        if let Some(positional) = self.get_positional_attribute(attributes, block_type) {
            parts.push(self.quote_positional_value(&positional.value));
        }
        
        // Handle key=value attributes
        for attr in attributes {
            if !self.is_positional_attribute(&attr.key, block_type) {
                let value = if attr.value.contains(' ') || attr.value.contains('"') {
                    format!("\"{}\"", attr.value.replace('"', "\\\""))
                } else {
                    attr.value.clone()
                };
                parts.push(format!("{}={}", attr.key, value));
            }
        }
        
        parts.join(" ")
    }
    
    fn get_positional_attribute<'a>(&self, attributes: &'a [Attribute], block_type: &BlockType) -> Option<&'a Attribute> {
        let positional_key = match block_type {
            BlockType::Section | BlockType::H1 | BlockType::H2 | 
            BlockType::H3 | BlockType::H4 | BlockType::H5 | BlockType::H6 => "title",
            BlockType::Image | BlockType::Img => "src",
            BlockType::Code | BlockType::C => "lang",
            BlockType::Quote | BlockType::Q => "author",
            BlockType::Table | BlockType::Tbl => "caption",
            _ => return None,
        };
        
        attributes.iter().find(|attr| attr.key == positional_key)
    }
    
    fn is_positional_attribute(&self, key: &str, block_type: &BlockType) -> bool {
        match block_type {
            BlockType::Section | BlockType::H1 | BlockType::H2 | 
            BlockType::H3 | BlockType::H4 | BlockType::H5 | BlockType::H6 => key == "title",
            BlockType::Image | BlockType::Img => key == "src",
            BlockType::Code | BlockType::C => key == "lang",
            BlockType::Quote | BlockType::Q => key == "author",
            BlockType::Table | BlockType::Tbl => key == "caption",
            _ => false,
        }
    }
    
    fn quote_positional_value(&self, value: &str) -> String {
        if value.is_empty() {
            format!("\"{}\"", value)
        } else {
            format!("\"{}\"", value.replace('"', "\\\""))
        }
    }
}

impl Default for BloxEncoder {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::blox::{BlockType, Block};
    
    #[test]
    fn test_simple_encoding() {
        let encoder = BloxEncoder::new();
        let mut doc = Document::new();
        
        let mut block = Block::new(BlockType::H1, 1, 1);
        block.add_attribute("title".to_string(), "Hello World".to_string());
        block.content = "This is content.".to_string();
        
        doc.blocks.push(block);
        
        let result = encoder.encode(&doc).unwrap();
        assert!(result.contains("#h1 \"Hello World\""));
        assert!(result.contains("This is content."));
    }
    
    #[test]
    fn test_attribute_encoding() {
        let encoder = BloxEncoder::new();
        let mut doc = Document::new();
        
        let mut block = Block::new(BlockType::Image, 1, 1);
        block.add_attribute("src".to_string(), "logo.png".to_string());
        block.add_attribute("alt".to_string(), "Company Logo".to_string());
        block.add_attribute("width".to_string(), "100".to_string());
        
        doc.blocks.push(block);
        
        let result = encoder.encode(&doc).unwrap();
        assert!(result.contains("#img \"logo.png\""));
        assert!(result.contains("alt=\"Company Logo\""));
        assert!(result.contains("width=100"));
    }
}
