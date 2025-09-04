use flutter_rust_bridge::frb;
use crate::blox::{BloxParser, BloxEncoder, BloxDecoder, Document, OutputFormat};

#[derive(Debug, Clone)]
#[frb]
pub struct BloxDocument {
    pub blocks: Vec<BloxBlock>,
    pub metadata: std::collections::HashMap<String, String>,
}

#[derive(Debug, Clone)]
#[frb]
pub struct BloxBlock {
    pub block_type: String,
    pub level: usize,
    pub attributes: std::collections::HashMap<String, String>,
    pub content: String,
    pub children: Vec<BloxBlock>,
    pub line_number: usize,
}

#[derive(Debug, Clone)]
#[frb]
pub enum BloxOutputFormat {
    Html,
    Markdown,
    Json,
    PlainText,
}

#[derive(Debug, Clone)]
#[frb]
pub struct ParseProgress {
    pub lines_processed: u64,
    pub total_lines: u64,
    pub current_section: String,
}

impl From<Document> for BloxDocument {
    fn from(doc: Document) -> Self {
        Self {
            blocks: doc.blocks.into_iter().map(Into::into).collect(),
            metadata: doc.metadata,
        }
    }
}

impl From<crate::blox::Block> for BloxBlock {
    fn from(block: crate::blox::Block) -> Self {
        let attributes = block.attributes
            .into_iter()
            .map(|attr| (attr.key, attr.value))
            .collect();
        
        Self {
            block_type: block.block_type.to_str().to_string(),
            level: block.level,
            attributes,
            content: block.content,
            children: block.children.into_iter().map(Into::into).collect(),
            line_number: block.line_number,
        }
    }
}

impl From<BloxOutputFormat> for OutputFormat {
    fn from(format: BloxOutputFormat) -> Self {
        match format {
            BloxOutputFormat::Html => OutputFormat::Html,
            BloxOutputFormat::Markdown => OutputFormat::Markdown,
            BloxOutputFormat::Json => OutputFormat::Json,
            BloxOutputFormat::PlainText => OutputFormat::PlainText,
        }
    }
}

/// Parse a Blox document from string content
#[frb(sync)]
pub fn parse_blox_string(content: String) -> Result<BloxDocument, String> {
    let mut parser = BloxParser::new();
    
    match parser.parse_string(&content) {
        Ok(document) => Ok(document.into()),
        Err(error) => Err(error.to_string()),
    }
}

/// Parse a Blox document from file
#[frb]
pub async fn parse_blox_file(file_path: String) -> Result<BloxDocument, String> {
    tokio::task::spawn_blocking(move || {
        let mut parser = BloxParser::new();
        
        match parser.parse_file(&file_path) {
            Ok(document) => Ok(document.into()),
            Err(error) => Err(error.to_string()),
        }
    }).await.map_err(|e| e.to_string())?
}

/// Encode a Blox document back to string format
#[frb(sync)]
pub fn encode_blox_document(document: BloxDocument, use_shorthand: bool) -> Result<String, String> {
    // Convert back to internal format
    let internal_doc = convert_to_internal_document(document);
    
    let encoder = BloxEncoder::with_options(0, use_shorthand);
    
    match encoder.encode(&internal_doc) {
        Ok(content) => Ok(content),
        Err(error) => Err(error.to_string()),
    }
}

/// Decode a Blox document to specified output format
#[frb(sync)]
pub fn decode_blox_document(
    document: BloxDocument, 
    format: BloxOutputFormat
) -> Result<String, String> {
    // Convert back to internal format
    let internal_doc = convert_to_internal_document(document);
    
    let decoder = BloxDecoder::new(format.into());
    
    match decoder.decode(&internal_doc) {
        Ok(content) => Ok(content),
        Err(error) => Err(error.to_string()),
    }
}

/// Parse large Blox file with progress updates
#[frb]
pub async fn parse_blox_file_with_progress(
    file_path: String,
    progress_callback: impl Fn(ParseProgress) + Send + 'static,
) -> Result<BloxDocument, String> {
    tokio::task::spawn_blocking(move || {
        // Read file to count lines first
        let content = std::fs::read_to_string(&file_path)
            .map_err(|e| e.to_string())?;
        
        let total_lines = content.lines().count() as u64;
        let mut lines_processed = 0u64;
        let mut current_section = "Starting...".to_string();
        
        let mut parser = BloxParser::new();
        
        // Parse line by line with progress updates
        for (line_num, line) in content.lines().enumerate() {
            lines_processed = line_num as u64 + 1;
            
            // Update current section based on line content
            if line.trim().starts_with('#') && line.contains("title=") {
                if let Some(start) = line.find("title=\"") {
                    let start = start + 7;
                    if let Some(end) = line[start..].find('"') {
                        current_section = line[start..start + end].to_string();
                    }
                }
            }
            
            // Send progress update every 100 lines or at end
            if lines_processed % 100 == 0 || lines_processed == total_lines {
                progress_callback(ParseProgress {
                    lines_processed,
                    total_lines,
                    current_section: current_section.clone(),
                });
            }
        }
        
        // Do actual parsing
        match parser.parse_string(&content) {
            Ok(document) => Ok(document.into()),
            Err(error) => Err(error.to_string()),
        }
    }).await.map_err(|e| e.to_string())?
}

/// Validate Blox syntax without full parsing
#[frb(sync)]
pub fn validate_blox_syntax(content: String) -> Result<Vec<String>, String> {
    let mut warnings = Vec::new();
    let mut current_level = 0;
    
    for (line_num, line) in content.lines().enumerate() {
        let line_number = line_num + 1;
        let trimmed = line.trim();
        
        // Skip empty lines and comments
        if trimmed.is_empty() || trimmed.starts_with("//") {
            continue;
        }
        
        // Check block syntax
        if trimmed.starts_with('#') {
            let level = trimmed.chars().take_while(|&c| c == '#').count();
            
            if level > 6 {
                warnings.push(format!("Line {}: Too many # symbols (max 6)", line_number));
            }
            
            if level > current_level + 1 {
                warnings.push(format!(
                    "Line {}: Invalid nesting - jumped from level {} to {}", 
                    line_number, current_level, level
                ));
            }
            
            current_level = level;
            
            // Check for block type after #
            let after_hashes = &trimmed[level..].trim_start();
            if after_hashes.is_empty() {
                warnings.push(format!("Line {}: Missing block type after #", line_number));
            } else if !after_hashes.chars().next().unwrap().is_alphabetic() {
                warnings.push(format!("Line {}: Block type must start with letter", line_number));
            }
        }
    }
    
    Ok(warnings)
}

fn convert_to_internal_document(doc: BloxDocument) -> Document {
    let mut internal_doc = Document::new();
    internal_doc.metadata = doc.metadata;
    internal_doc.blocks = doc.blocks.into_iter().map(convert_to_internal_block).collect();
    internal_doc
}

fn convert_to_internal_block(block: BloxBlock) -> crate::blox::Block {
    let block_type = crate::blox::BlockType::from_str(&block.block_type);
    let mut internal_block = crate::blox::Block::new(block_type, block.level, block.line_number);
    
    internal_block.content = block.content;
    internal_block.attributes = block.attributes
        .into_iter()
        .map(|(k, v)| crate::blox::Attribute { key: k, value: v })
        .collect();
    
    internal_block.children = block.children
        .into_iter()
        .map(convert_to_internal_block)
        .collect();
    
    internal_block
}
