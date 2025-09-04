use crate::blox::{Document, Block, InlineElement, BloxError, ParseResult};
use std::collections::HashMap;

pub struct BloxDecoder {
    output_format: OutputFormat,
}

#[derive(Debug, Clone)]
pub enum OutputFormat {
    Html,
    Markdown,
    Json,
    PlainText,
}

impl BloxDecoder {
    pub fn new(format: OutputFormat) -> Self {
        Self {
            output_format: format,
        }
    }
    
    /// Decode a Blox document to the specified output format
    pub fn decode(&self, document: &Document) -> ParseResult<String> {
        match self.output_format {
            OutputFormat::Html => self.to_html(document),
            OutputFormat::Markdown => self.to_markdown(document),
            OutputFormat::Json => self.to_json(document),
            OutputFormat::PlainText => self.to_plain_text(document),
        }
    }
    
    fn to_html(&self, document: &Document) -> ParseResult<String> {
        let mut output = String::new();
        
        output.push_str("<!DOCTYPE html>\n<html>\n<head>\n");
        output.push_str("<meta charset=\"UTF-8\">\n");
        
        if let Some(title) = document.metadata.get("title") {
            output.push_str(&format!("<title>{}</title>\n", html_escape(title)));
        }
        
        output.push_str("</head>\n<body>\n");
        
        for block in &document.blocks {
            self.block_to_html(&mut output, block, 0)?;
        }
        
        output.push_str("</body>\n</html>");
        Ok(output)
    }
    
    fn block_to_html(&self, output: &mut String, block: &Block, depth: usize) -> ParseResult<()> {
        let indent = "  ".repeat(depth);
        
        match &block.block_type {
            crate::blox::BlockType::Section | 
            crate::blox::BlockType::H1 | crate::blox::BlockType::H2 | 
            crate::blox::BlockType::H3 | crate::blox::BlockType::H4 | 
            crate::blox::BlockType::H5 | crate::blox::BlockType::H6 => {
                let level = match &block.block_type {
                    crate::blox::BlockType::H1 => 1,
                    crate::blox::BlockType::H2 => 2,
                    crate::blox::BlockType::H3 => 3,
                    crate::blox::BlockType::H4 => 4,
                    crate::blox::BlockType::H5 => 5,
                    crate::blox::BlockType::H6 => 6,
                    _ => std::cmp::min(block.level, 6),
                };
                
                let title = block.get_attribute("title").unwrap_or("");
                output.push_str(&format!("{}<h{}>{}</h{}>\n", 
                    indent, level, html_escape(title), level));
                
                if !block.content.is_empty() {
                    output.push_str(&format!("{}<p>{}</p>\n", 
                        indent, html_escape(&block.content)));
                }
            }
            
            crate::blox::BlockType::Paragraph | crate::blox::BlockType::P => {
                output.push_str(&format!("{}<p>{}</p>\n", 
                    indent, html_escape(&block.content)));
            }
            
            crate::blox::BlockType::Code | crate::blox::BlockType::C => {
                let lang = block.get_attribute("lang").unwrap_or("");
                let class_attr = if lang.is_empty() {
                    String::new()
                } else {
                    format!(" class=\"language-{}\"", lang)
                };
                
                output.push_str(&format!("{}<pre><code{}>{}</code></pre>\n",
                    indent, class_attr, html_escape(&block.content)));
            }
            
            crate::blox::BlockType::Quote | crate::blox::BlockType::Q => {
                output.push_str(&format!("{}<blockquote>\n", indent));
                output.push_str(&format!("{}  <p>{}</p>\n", 
                    indent, html_escape(&block.content)));
                
                if let Some(author) = block.get_attribute("author") {
                    output.push_str(&format!("{}  <cite>{}</cite>\n", 
                        indent, html_escape(author)));
                }
                
                output.push_str(&format!("{}</blockquote>\n", indent));
            }
            
            crate::blox::BlockType::Image | crate::blox::BlockType::Img => {
                let src = block.get_attribute("src").unwrap_or("");
                let alt = block.get_attribute("alt").unwrap_or("");
                let width = block.get_attribute("width");
                let height = block.get_attribute("height");
                
                let mut attrs = format!("src=\"{}\" alt=\"{}\"", 
                    html_escape(src), html_escape(alt));
                
                if let Some(w) = width {
                    attrs.push_str(&format!(" width=\"{}\"", html_escape(w)));
                }
                if let Some(h) = height {
                    attrs.push_str(&format!(" height=\"{}\"", html_escape(h)));
                }
                
                output.push_str(&format!("{}<img {} />\n", indent, attrs));
            }
            
            crate::blox::BlockType::List => {
                output.push_str(&format!("{}<ul>\n", indent));
                for line in block.content.lines() {
                    if !line.trim().is_empty() {
                        output.push_str(&format!("{}  <li>{}</li>\n", 
                            indent, html_escape(line.trim())));
                    }
                }
                output.push_str(&format!("{}</ul>\n", indent));
            }
            
            crate::blox::BlockType::Table | crate::blox::BlockType::Tbl => {
                output.push_str(&format!("{}<table>\n", indent));
                
                if let Some(caption) = block.get_attribute("caption") {
                    output.push_str(&format!("{}  <caption>{}</caption>\n", 
                        indent, html_escape(caption)));
                }
                
                let lines: Vec<&str> = block.content.lines().collect();
                if !lines.is_empty() {
                    // First line as header
                    output.push_str(&format!("{}  <thead>\n{}    <tr>\n", indent, indent));
                    for cell in lines[0].split('|') {
                        output.push_str(&format!("{}      <th>{}</th>\n", 
                            indent, html_escape(cell.trim())));
                    }
                    output.push_str(&format!("{}    </tr>\n{}  </thead>\n", indent, indent));
                    
                    // Remaining lines as body
                    if lines.len() > 1 {
                        output.push_str(&format!("{}  <tbody>\n", indent));
                        for line in &lines[1..] {
                            if !line.trim().is_empty() {
                                output.push_str(&format!("{}    <tr>\n", indent));
                                for cell in line.split('|') {
                                    output.push_str(&format!("{}      <td>{}</td>\n", 
                                        indent, html_escape(cell.trim())));
                                }
                                output.push_str(&format!("{}    </tr>\n", indent));
                            }
                        }
                        output.push_str(&format!("{}  </tbody>\n", indent));
                    }
                }
                
                output.push_str(&format!("{}</table>\n", indent));
            }
            
            crate::blox::BlockType::Math | crate::blox::BlockType::M => {
                output.push_str(&format!("{}<div class=\"math\">\n", indent));
                output.push_str(&format!("{}  $${}$$\n", indent, block.content));
                output.push_str(&format!("{}</div>\n", indent));
            }
            
            _ => {
                // Custom or unknown block types
                output.push_str(&format!("{}<div class=\"{}\">\n", 
                    indent, block.block_type.to_str()));
                if !block.content.is_empty() {
                    output.push_str(&format!("{}  {}\n", indent, html_escape(&block.content)));
                }
                output.push_str(&format!("{}</div>\n", indent));
            }
        }
        
        // Process children
        for child in &block.children {
            self.block_to_html(output, child, depth + 1)?;
        }
        
        Ok(())
    }
    
    fn to_markdown(&self, document: &Document) -> ParseResult<String> {
        let mut output = String::new();
        
        for block in &document.blocks {
            self.block_to_markdown(&mut output, block)?;
            output.push('\n');
        }
        
        Ok(output)
    }
    
    fn block_to_markdown(&self, output: &mut String, block: &Block) -> ParseResult<()> {
        match &block.block_type {
            crate::blox::BlockType::Section | 
            crate::blox::BlockType::H1 | crate::blox::BlockType::H2 | 
            crate::blox::BlockType::H3 | crate::blox::BlockType::H4 | 
            crate::blox::BlockType::H5 | crate::blox::BlockType::H6 => {
                let level = match &block.block_type {
                    crate::blox::BlockType::H1 => 1,
                    crate::blox::BlockType::H2 => 2,
                    crate::blox::BlockType::H3 => 3,
                    crate::blox::BlockType::H4 => 4,
                    crate::blox::BlockType::H5 => 5,
                    crate::blox::BlockType::H6 => 6,
                    _ => block.level,
                };
                
                let title = block.get_attribute("title").unwrap_or("");
                output.push_str(&format!("{} {}\n", "#".repeat(level), title));
                
                if !block.content.is_empty() {
                    output.push('\n');
                    output.push_str(&block.content);
                    output.push('\n');
                }
            }
            
            crate::blox::BlockType::Paragraph | crate::blox::BlockType::P => {
                output.push_str(&block.content);
                output.push('\n');
            }
            
            crate::blox::BlockType::Code | crate::blox::BlockType::C => {
                let lang = block.get_attribute("lang").unwrap_or("");
                output.push_str(&format!("```{}\n{}\n```\n", lang, block.content));
            }
            
            crate::blox::BlockType::Quote | crate::blox::BlockType::Q => {
                for line in block.content.lines() {
                    output.push_str(&format!("> {}\n", line));
                }
                
                if let Some(author) = block.get_attribute("author") {
                    output.push_str(&format!("> \n> — {}\n", author));
                }
            }
            
            crate::blox::BlockType::Image | crate::blox::BlockType::Img => {
                let src = block.get_attribute("src").unwrap_or("");
                let alt = block.get_attribute("alt").unwrap_or("");
                output.push_str(&format!("![{}]({})\n", alt, src));
            }
            
            _ => {
                // For other block types, just output content
                output.push_str(&block.content);
                output.push('\n');
            }
        }
        
        // Process children
        for child in &block.children {
            self.block_to_markdown(output, child)?;
        }
        
        Ok(())
    }
    
    fn to_json(&self, document: &Document) -> ParseResult<String> {
        serde_json::to_string_pretty(document)
            .map_err(|e| BloxError::ParseError { 
                line: 0, 
                message: format!("JSON serialization error: {}", e) 
            })
    }
    
    fn to_plain_text(&self, document: &Document) -> ParseResult<String> {
        let mut output = String::new();
        
        for block in &document.blocks {
            self.block_to_plain_text(&mut output, block, 0);
            output.push('\n');
        }
        
        Ok(output)
    }
    
    fn block_to_plain_text(&self, output: &mut String, block: &Block, depth: usize) {
        let indent = "  ".repeat(depth);
        
        // Add title if it exists
        if let Some(title) = block.get_attribute("title") {
            output.push_str(&format!("{}{}\n", indent, title));
        }
        
        // Add content
        if !block.content.is_empty() {
            for line in block.content.lines() {
                output.push_str(&format!("{}{}\n", indent, line));
            }
        }
        
        // Process children
        for child in &block.children {
            self.block_to_plain_text(output, child, depth + 1);
        }
    }
}

fn html_escape(text: &str) -> String {
    text.replace('&', "&amp;")
        .replace('<', "&lt;")
        .replace('>', "&gt;")
        .replace('"', "&quot;")
        .replace('\'', "&#39;")
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::blox::{BlockType, Block, Attribute};
    
    #[test]
    fn test_html_output() {
        let decoder = BloxDecoder::new(OutputFormat::Html);
        let mut doc = Document::new();
        
        let mut block = Block::new(BlockType::H1, 1, 1);
        block.add_attribute("title".to_string(), "Hello World".to_string());
        doc.blocks.push(block);
        
        let result = decoder.decode(&doc).unwrap();
        assert!(result.contains("<h1>Hello World</h1>"));
        assert!(result.contains("<!DOCTYPE html>"));
    }
    
    #[test]
    fn test_markdown_output() {
        let decoder = BloxDecoder::new(OutputFormat::Markdown);
        let mut doc = Document::new();
        
        let mut block = Block::new(BlockType::H1, 1, 1);
        block.add_attribute("title".to_string(), "Hello World".to_string());
        doc.blocks.push(block);
        
        let result = decoder.decode(&doc).unwrap();
        assert!(result.contains("# Hello World"));
    }
}
