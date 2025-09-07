use std::collections::HashMap;
use lazy_static::lazy_static;

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct Document {
    pub blocks: Vec<Block>,
    pub metadata: HashMap<String, String>,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct Block {
    pub block_type: BlockType,
    pub level: usize,
    pub attributes: Vec<Attribute>,
    pub content: String,
    pub children: Vec<Block>,
    pub line_number: usize,
    // Enhanced content structures
    pub inline_elements: Vec<InlineElement>,
    pub list_items: Vec<ListItem>,
    pub table: Option<Table>,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
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

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct Attribute {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum InlineElement {
    Text(String),
    Link { text: String, url: String },
    Bold(String),
    Italic(String),
    Code(String),
    Math(String),
    Strikethrough(String),
    Highlight(String),
    Subscript(String),
    Superscript(String),
    Reference(String),
    Footnote { id: String, text: String },
    Custom { element_type: String, attributes: Vec<Attribute>, content: String },
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum ListType {
    Unordered,
    Ordered,
    Check,
    Definition,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum ListItemType {
    Unchecked,
    Checked,
    Definition { term: String },
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct ListItem {
    pub item_type: ListItemType,
    pub content: String,
    pub children: Vec<ListItem>,
    pub level: usize,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct TableCell {
    pub content: String,
    pub colspan: usize,
    pub rowspan: usize,
    pub is_header: bool,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct TableRow {
    pub cells: Vec<TableCell>,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct Table {
    pub caption: Option<String>,
    pub header: Option<TableRow>,
    pub rows: Vec<TableRow>,
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
            inline_elements: Vec::new(),
            list_items: Vec::new(),
            table: None,
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
    
    /// Parse inline elements from content
    pub fn parse_inline_elements(&mut self) -> Result<(), String> {
        use regex::Regex;
        use lazy_static::lazy_static;
        
        lazy_static! {
            static ref BOLD: Regex = Regex::new(r"\*\*([^*]+)\*\*").unwrap();
            static ref ITALIC: Regex = Regex::new(r"\*([^*]+)\*").unwrap();
            static ref CODE_INLINE: Regex = Regex::new(r"`([^`]+)`").unwrap();
            static ref LINK: Regex = Regex::new(r"\[([^\]]+)\]\(([^)]+)\)").unwrap();
            static ref STRIKETHROUGH: Regex = Regex::new(r"~~([^~]+)~~").unwrap();
            static ref HIGHLIGHT: Regex = Regex::new(r"==([^=]+)==").unwrap();
            static ref SUPERSCRIPT: Regex = Regex::new(r"\^([^^]+)\^").unwrap();
            static ref SUBSCRIPT: Regex = Regex::new(r"_([^_]+)_").unwrap();
            static ref MATH_INLINE: Regex = Regex::new(r"\$([^$]+)\$").unwrap();
        }
        
        if self.content.is_empty() {
            self.inline_elements = vec![InlineElement::Text(self.content.clone())];
            return Ok(());
        }
        
        let mut elements = Vec::new();
        let _remaining = self.content.clone();
        let _last_end = 0;
        
        // Collect all matches with their positions
        let mut matches = Vec::new();
        
        // Bold matches
        for cap in BOLD.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Bold(cap[1].to_string())));
            }
        }
        
        // Italic matches
        for cap in ITALIC.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Italic(cap[1].to_string())));
            }
        }
        
        // Code matches
        for cap in CODE_INLINE.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Code(cap[1].to_string())));
            }
        }
        
        // Link matches
        for cap in LINK.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Link { 
                    text: cap[1].to_string(), 
                    url: cap[2].to_string() 
                }));
            }
        }
        
        // Strikethrough matches
        for cap in STRIKETHROUGH.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Strikethrough(cap[1].to_string())));
            }
        }
        
        // Highlight matches
        for cap in HIGHLIGHT.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Highlight(cap[1].to_string())));
            }
        }
        
        // Superscript matches
        for cap in SUPERSCRIPT.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Superscript(cap[1].to_string())));
            }
        }
        
        // Subscript matches
        for cap in SUBSCRIPT.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Subscript(cap[1].to_string())));
            }
        }
        
        // Math matches
        for cap in MATH_INLINE.captures_iter(&self.content) {
            if let Some(m) = cap.get(0) {
                matches.push((m.start(), m.end(), InlineElement::Math(cap[1].to_string())));
            }
        }
        
        // Sort matches by start position
        matches.sort_by_key(|(start, _, _)| *start);
        
        // Build elements from matches
        let mut pos = 0;
        for (start, end, element) in matches {
            if start > pos {
                // Add text before this match
                let text = self.content[pos..start].to_string();
                if !text.is_empty() {
                    elements.push(InlineElement::Text(text));
                }
            }
            elements.push(element);
            pos = end;
        }
        
        // Add remaining text
        if pos < self.content.len() {
            let text = self.content[pos..].to_string();
            if !text.is_empty() {
                elements.push(InlineElement::Text(text));
            }
        }
        
        // If no elements were found, treat the whole content as text
        if elements.is_empty() {
            elements.push(InlineElement::Text(self.content.clone()));
        }
        
        self.inline_elements = elements;
        Ok(())
    }
    
    /// Parse list items from content
    pub fn parse_list_items(&mut self) -> Result<(), String> {
        if self.content.is_empty() {
            return Ok(());
        }
        
        let list_type = match self.get_attribute("type").unwrap_or("unordered") {
            "ordered" => ListType::Ordered,
            "check" => ListType::Check,
            "definition" => ListType::Definition,
            _ => ListType::Unordered,
        };
        
        let mut items = Vec::new();
        let lines: Vec<&str> = self.content.lines().collect();
        let mut current_item: Option<ListItem> = None;
        let mut current_level = 0;
        
        for line in lines {
            let trimmed = line.trim();
            if trimmed.is_empty() {
                continue;
            }
            
            // Count leading dashes to determine level
            let level = line.chars().take_while(|&c| c == '-').count();
            
            if level > 0 {
                // This is a list item
                let content = line[level..].trim();
                
                let item_type = if content.starts_with("[x] ") || content.starts_with("[X] ") {
                    ListItemType::Checked
                } else if content.starts_with("[ ] ") {
                    ListItemType::Unchecked
                } else if list_type == ListType::Definition && content.contains(": ") {
                    let parts: Vec<&str> = content.splitn(2, ": ").collect();
                    if parts.len() == 2 {
                        ListItemType::Definition { term: parts[0].to_string() }
                    } else {
                        ListItemType::Unchecked
                    }
                } else {
                    ListItemType::Unchecked
                };
                
                let clean_content = match &item_type {
                    ListItemType::Checked => content[4..].to_string(),
                    ListItemType::Unchecked if content.starts_with("[ ] ") => content[4..].to_string(),
                    ListItemType::Definition { .. } => {
                        let parts: Vec<&str> = content.splitn(2, ": ").collect();
                        if parts.len() == 2 { parts[1].to_string() } else { content.to_string() }
                    }
                    _ => content.to_string(),
                };
                
                let new_item = ListItem {
                    item_type,
                    content: clean_content,
                    children: Vec::new(),
                    level,
                };
                
                if level > current_level {
                    // This is a child of the current item
                    if let Some(ref mut parent) = current_item {
                        parent.children.push(new_item);
                    }
                } else {
                    // This is a sibling or parent level item
                    if let Some(item) = current_item.take() {
                        items.push(item);
                    }
                    current_item = Some(new_item);
                }
                
                current_level = level;
            } else if let Some(ref mut item) = current_item {
                // Continuation of current item
                if !item.content.is_empty() {
                    item.content.push('\n');
                }
                item.content.push_str(line);
            }
        }
        
        if let Some(item) = current_item {
            items.push(item);
        }
        
        self.list_items = items;
        Ok(())
    }
    
    /// Parse table from content
    pub fn parse_table(&mut self) -> Result<(), String> {
        if self.content.is_empty() {
            return Ok(());
        }
        
        let caption = self.get_attribute("caption").map(|s| s.to_string());
        let has_header = self.get_attribute("header").unwrap_or("false") == "true";
        
        let lines: Vec<&str> = self.content.lines()
            .map(|line| line.trim())
            .filter(|line| !line.is_empty())
            .collect();
        
        if lines.is_empty() {
            return Ok(());
        }
        
        let mut rows = Vec::new();
        let mut header_row = None;
        
        for (i, line) in lines.iter().enumerate() {
            let cells: Vec<&str> = line.split('|').map(|cell| cell.trim()).collect();
            let is_header = has_header && i == 0;
            
            let table_cells: Vec<TableCell> = cells.iter().map(|cell| {
                TableCell {
                    content: cell.to_string(),
                    colspan: 1,
                    rowspan: 1,
                    is_header,
                }
            }).collect();
            
            let row = TableRow { cells: table_cells };
            
            if is_header {
                header_row = Some(row);
            } else {
                rows.push(row);
            }
        }
        
        self.table = Some(Table {
            caption,
            header: header_row,
            rows,
        });
        
        Ok(())
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
