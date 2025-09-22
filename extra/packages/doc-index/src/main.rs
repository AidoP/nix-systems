type Error = Box<dyn std::error::Error>;

use clap::Parser;
use std::{collections::HashMap, ffi::{OsStr, OsString}, fs, io::{self, BufRead}, path::{Path, PathBuf}};

#[derive(Parser, Debug)]
struct Args {
    /// Directories to list documentation from.
    dir: Vec<PathBuf>,
    /// Configuration file to read.
    #[arg(short)]
    config: Option<PathBuf>,
}

fn main() -> iced::Result {
    let args = Args::parse();
    iced::run("Documentation", Viewer::update, Viewer::view)
}

use iced::widget;

#[derive(Debug)]
enum Message {

}

#[derive(Default)]
struct Viewer;
impl Viewer {
    pub fn view(&self) -> widget::Column<Message> {
        widget::column![
            widget::text("Hello, World!"),
        ]
    }
    pub fn update(&mut self, message: Message) {

    }
}

//
//     let mut output = args.dir.clone();
//     output.push("doc-cache");
//     if output.exists() {
//         return Ok(());
//     }
//     let mut output = fs::File::create(&output)?;
//
//
//     let mut pdfs = HashMap::<PathBuf, String>::new();
//     for file in fs::read_dir(&args.dir)? {
//         let Ok(file) = file else {
//             continue;
//         };
//         if !file.file_type()?.is_file() {
//             continue;
//         }
//         let Ok(name) = file.file_name().into_string() else {
//             continue;
//         };
//         if !name.ends_with(".pdf") {
//             continue;
//         }
//         let path = file.path();
//         let pdf_title = pdf_title(&path)?;
//         pdfs.insert(path, pdf_title);
//     }
//     use std::io::Write;
//     for (file, title) in pdfs {
//         writeln!(output, "{}\0{title}", file.as_os_str().to_str().unwrap())?;
//     }
//     //serde_json::to_writer_pretty(output, &pdfs)?;
//     Ok(())
// }
//
// fn generate_index() -> Result<(), Error> {
//
// }
//
// fn pdf_title(pdf: &Path) -> Result<String, Error> {
//     let title = std::process::Command::new("pdfinfo")
//         .arg(pdf)
//         .output()?
//         .stdout
//         .split(|&b| b == b'\n')
//         .filter(|l| l.starts_with(b"Title: "))
//         .map(|s| String::from_utf8(s[6..].into()))
//         .next()
//         .unwrap_or_else(|| Ok(pdf.file_stem()
//             .and_then(OsStr::to_str)
//             .unwrap_or("invalid PDF title")
//             .into())
//         )?;
//     Ok(title.trim().into())
// }
//
