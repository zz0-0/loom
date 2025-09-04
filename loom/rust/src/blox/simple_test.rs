use crate::blox::ast::*;
use crate::blox::parser::*;

#[test]
fn test_basic_functionality() {
    let mut parser = BloxParser::new();
    let content = "#h1 \"Hello World\"\nThis is content";
    
    let result = parser.parse_string(content);
    println!("Parse result: {:?}", result);
    assert!(result.is_ok());
    
    let doc = result.unwrap();
    assert_eq!(doc.blocks.len(), 1);
    assert_eq!(doc.blocks[0].block_type, BlockType::H1);
}

#[test]
fn test_block_types() {
    assert_eq!(BlockType::from_str("h1"), BlockType::H1);
    assert_eq!(BlockType::from_str("section"), BlockType::Section);
    assert_eq!(BlockType::from_str("code"), BlockType::Code);
}
