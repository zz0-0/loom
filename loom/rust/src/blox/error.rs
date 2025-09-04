use thiserror::Error;

#[derive(Error, Debug)]
pub enum BloxError {
    #[error("Parse error at line {line}: {message}")]
    ParseError { line: usize, message: String },
    
    #[error("Invalid block nesting at line {line}: expected level {expected}, got {actual}")]
    InvalidNesting { line: usize, expected: usize, actual: usize },
    
    #[error("Unknown block type: {block_type}")]
    UnknownBlockType { block_type: String },
    
    #[error("Invalid attribute syntax at line {line}: {attribute}")]
    InvalidAttribute { line: usize, attribute: String },
    
    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),
    
    #[error("UTF-8 encoding error: {0}")]
    Utf8Error(#[from] std::str::Utf8Error),
}

pub type ParseResult<T> = Result<T, BloxError>;
