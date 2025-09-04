use crate::blox::ast::*;
use crate::blox::parser::*;
use crate::blox::encoder::*;

#[test]
fn test_comprehensive_parsing() {
    let mut parser = BloxParser::new();
    let content = r#"
#h1 "Welcome to Blox"
This is the introduction paragraph.

#h2 "Features"
Blox has many great features:

##code lang=rust
fn hello() {
    println!("Hello, Blox!");
}

##p
This is a nested paragraph.

#h2 "Conclusion"
That's all for now!
"#;
    
    let result = parser.parse_string(content);
    assert!(result.is_ok(), "Parsing should succeed");
    
    let doc = result.unwrap();
    println!("Parsed document: {:#?}", doc);
    
    assert_eq!(doc.blocks.len(), 3, "Should have 3 top-level blocks");
    
    // Test first block
    assert_eq!(doc.blocks[0].block_type, BlockType::H1);
    assert_eq!(doc.blocks[0].get_attribute("title"), Some("Welcome to Blox"));
    assert!(doc.blocks[0].content.contains("introduction"));
    
    // Test second block with children
    assert_eq!(doc.blocks[1].block_type, BlockType::H2);
    assert_eq!(doc.blocks[1].get_attribute("title"), Some("Features"));
    assert_eq!(doc.blocks[1].children.len(), 2, "Should have 2 child blocks");
    
    // Test code block child
    let code_block = &doc.blocks[1].children[0];
    assert_eq!(code_block.block_type, BlockType::Code);
    assert_eq!(code_block.get_attribute("lang"), Some("rust"));
    assert!(code_block.content.contains("println!"));
}

#[test]
fn test_encoding_roundtrip() {
    let mut doc = Document::new();
    
    let mut h1_block = Block::new(BlockType::H1, 1, 1);
    h1_block.add_attribute("title".to_string(), "Test Title".to_string());
    h1_block.content = "Test content".to_string();
    
    doc.blocks.push(h1_block);
    
    let encoder = BloxEncoder::new();
    let encoded = encoder.encode(&doc).unwrap();
    
    println!("Encoded: {}", encoded);
    
    assert!(encoded.contains("#h1 \"Test Title\""));
    assert!(encoded.contains("Test content"));
    
    // Test roundtrip
    let mut parser = BloxParser::new();
    let parsed = parser.parse_string(&encoded).unwrap();
    
    assert_eq!(parsed.blocks.len(), 1);
    assert_eq!(parsed.blocks[0].get_attribute("title"), Some("Test Title"));
}

#[test] 
fn test_shorthand_syntax() {
    let mut parser = BloxParser::new();
    let content = r#"
#h1 "Header 1"
#h2 "Header 2"  
#p
This is a paragraph.
#c rust
println!("code");
#img "logo.png"
"#;
    
    let doc = parser.parse_string(content).unwrap();
    println!("Shorthand document: {:#?}", doc);
    
    assert_eq!(doc.blocks.len(), 5);
    
    assert_eq!(doc.blocks[0].block_type, BlockType::H1);
    assert_eq!(doc.blocks[1].block_type, BlockType::H2);
    assert_eq!(doc.blocks[2].block_type, BlockType::P);
    assert_eq!(doc.blocks[3].block_type, BlockType::C);
    assert_eq!(doc.blocks[4].block_type, BlockType::Img);
    
    // Test positional attributes
    assert_eq!(doc.blocks[0].get_attribute("title"), Some("Header 1"));
    assert_eq!(doc.blocks[3].get_attribute("lang"), Some("rust"));
    assert_eq!(doc.blocks[4].get_attribute("src"), Some("logo.png"));
}
