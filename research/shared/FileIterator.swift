
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

struct FileIterator {
}

/*

 struct FileLineIterator: IteratorProtocol {
     private let fileHandle: FileHandle
     private var buffer: String?

     init?(fileURL: URL) {
         guard FileManager.default.fileExists(atPath: fileURL.path) else {
             return nil
         }
         self.fileHandle = try! FileHandle(forReadingFrom: fileURL)
     }

     mutating func next() -> String? {
         // Чтение данных из файла
         let data = fileHandle.readData(ofLength: 1024)

         // Если конец файла, закрываем хэндл и возвращаем nil
         if data.isEmpty {
             fileHandle.closeFile()
             return nil
         }

         // Преобразование данных в строку
         let newLines = String(data: data, encoding: .utf8)?
             .components(separatedBy: .newlines)

         if let lastLine = newLines?.last, let buffer = buffer {
             self.buffer = buffer + lastLine // Сохраняем остаток строки
             return buffer
         } else {
             return newLines?.first // Возвращаем первую строку
         }
     }
 }

 struct FileLineSequence: Sequence {
     let fileURL: URL

     func makeIterator() -> FileLineIterator? {
         return FileLineIterator(fileURL: fileURL)
     }
 }

 // Пример использования
 if let fileIterator = FileLineSequence(fileURL: URL(fileURLWithPath: "path/to/your/file.txt")) {
     for line in fileIterator {
         print(line)
     }
 }

*/
