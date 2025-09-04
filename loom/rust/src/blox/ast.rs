use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq)]
pub struct Document {
    pub blocks: Vec<Block>,
    pub metadata: HashMap<String, String>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Block {
    pub block_type: BlockType,
    pub level: usize,
    pub attributes: Vec<Attribute>,
    pub content: String,
    pub children: Vec<Block>,
    pub line_number: usize,
}

#[derive(Debug, Clone, PartialEq)]
pub enum BlockType {
    // Core blocks
    Section,
    Paragraph,
    Code,
    Quote,
    Image,
    Table,
    List,
    Math,
    Comment,
    
    // Shorthand aliases
    H1, H2, H3, H4, H5, H6,  // Headers
    P,                        // Paragraph
    C,                        // Code
    Q,                        // Quote
    Img,                      // Image
    Tbl,                      // Table
    M,                        // Math
    
    // Custom/unknown blocks
    Custom(String),
}

#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Clone, PartialEq)]
pub enum InlineElement {
    Text(String),
    Link { text: String, url: String },
    Bold(String),
    Italic(String),
    Code(String),
    Math(String),
    Custom { element_type: String, content: String },
}

impl Document {
    pub fn new() -> Self {
        Self {
            blocks: Vec::new(),
            metadata: HashMap::new(),
        }
    }
}

impl Block {
    pub fn new(block_type: BlockType, level: usize, line_number: usize) -> Self {
        Self {
            block_type,
            level,
            attributes: Vec::new(),
            content: String::new(),
            children: Vec::new(),
            line_number,
        }
    }
    
    pub fn add_attribute(&mut self, key: String, value: String) {
        self.attributes.push(Attribute { key, value });
    }
    
    pub fn get_attribute(&self, key: &str) -> Option<&str> {
        self.attributes
            .iter()
            .find(|attr| attr.key == key)
            .map(|attr| attr.value.as_str())
    }
}

impl BlockType {
    pub fn from_str(s: &str) -> Self {
        match s.to_lowercase().as_str() {
            "section" => BlockType::Section,
            "paragraph" => BlockType::Paragraph,
            "code" => BlockType::Code,
            "quote" => BlockType::Quote,
            "image" => BlockType::Image,
            "table" => BlockType::Table,
            "list" => BlockType::List,
            "math" => BlockType::Math,
            "comment" => BlockType::Comment,
            
            // Shorthand
            "h1" => BlockType::H1,
            "h2" => BlockType::H2,
            "h3" => BlockType::H3,
            "h4" => BlockType::H4,
            "h5" => BlockType::H5,
            "h6" => BlockType::H6,
            "p" => BlockType::P,
            "c" => BlockType::C,
            "q" => BlockType::Q,
            "img" => BlockType::Img,
            "tbl" => BlockType::Tbl,
            "m" => BlockType::M,
            
            _ => BlockType::Custom(s.to_string()),
        }
    }
    
    pub fn to_str(&self) -> &str {
        match self {
            BlockType::Section => "section",
            BlockType::Paragraph => "paragraph",
            BlockType::Code => "code",
            BlockType::Quote => "quote",
            BlockType::Image => "image",
            BlockType::Table => "table",
            BlockType::List => "list",
            BlockType::Math => "math",
            BlockType::Comment => "comment",
            
            BlockType::H1 => "h1",
            BlockType::H2 => "h2",
            BlockType::H3 => "h3",
            BlockType::H4 => "h4",
            BlockType::H5 => "h5",
            BlockType::H6 => "h6",
            BlockType::P => "p",
            BlockType::C => "c",
            BlockType::Q => "q",
            BlockType::Img => "img",
            BlockType::Tbl => "tbl",
            BlockType::M => "m",
            
            BlockType::Custom(name) => name,
        }
    }
    
    /// Convert shorthand to canonical form
    pub fn canonical(&self) -> BlockType {
        match self {
            BlockType::H1 | BlockType::H2 | BlockType::H3 |
            BlockType::H4 | BlockType::H5 | BlockType::H6 => BlockType::Section,
            BlockType::P => BlockType::Paragraph,
            BlockType::C => BlockType::Code,
            BlockType::Q => BlockType::Quote,
            BlockType::Img => BlockType::Image,
            BlockType::Tbl => BlockType::Table,
            BlockType::M => BlockType::Math,
            _ => self.clone(),
        }
    }
}
