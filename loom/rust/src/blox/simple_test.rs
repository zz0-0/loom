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
fn test_enhanced_blox_features() {
    let mut parser = BloxParser::new();
    let content = r#"
#h1 "Enhanced Blox Demo"

This shows **bold**, *italic*, `code`, and [link](url).

#list type=unordered
- Item 1
- Item 2
  - Nested item

#table header=true
Name | Value
Test | 123
"#;

    let doc = parser.parse_string(content).unwrap();

    // Check that we have blocks
    assert!(!doc.blocks.is_empty());

    // Find the H1 block which contains the inline elements
    let h1_block = doc.blocks.iter()
        .find(|b| matches!(b.block_type, BlockType::H1))
        .expect("Should have an H1 block");

    // Check that inline elements were parsed
    assert!(!h1_block.inline_elements.is_empty());

    // Check for specific inline elements
    let has_bold = h1_block.inline_elements.iter()
        .any(|elem| matches!(elem, InlineElement::Bold(_)));
    assert!(has_bold, "Should have bold inline element");

    let has_italic = h1_block.inline_elements.iter()
        .any(|elem| matches!(elem, InlineElement::Italic(_)));
    assert!(has_italic, "Should have italic inline element");

    let has_code = h1_block.inline_elements.iter()
        .any(|elem| matches!(elem, InlineElement::Code(_)));
    assert!(has_code, "Should have code inline element");

    let has_link = h1_block.inline_elements.iter()
        .any(|elem| matches!(elem, InlineElement::Link { .. }));
    assert!(has_link, "Should have link inline element");

    // Find the list block
    let list_block = doc.blocks.iter()
        .find(|b| matches!(b.block_type, BlockType::List))
        .expect("Should have a list block");

    // Check that list items were parsed
    assert!(!list_block.list_items.is_empty());

    // Find the table block
    let table_block = doc.blocks.iter()
        .find(|b| matches!(b.block_type, BlockType::Table))
        .expect("Should have a table block");

    // Check that table was parsed
    assert!(table_block.table.is_some());
    let table = table_block.table.as_ref().unwrap();
    assert!(table.header.is_some());
    assert_eq!(table.rows.len(), 1); // One data row

    println!("✅ All enhanced Blox features working correctly!");
}
