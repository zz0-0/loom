pub mod parser;
pub mod encoder;
// pub mod decoder;  // Disable temporarily
pub mod ast;
pub mod error;

#[cfg(test)]
mod simple_test;

#[cfg(test)]
mod comprehensive_test;

pub use parser::BloxParser;
pub use encoder::BloxEncoder;
// pub use decoder::{BloxDecoder, OutputFormat};  // Disable temporarily
pub use ast::{Document, Block, BlockType, Attribute, InlineElement};
pub use error::{BloxError, ParseResult};
