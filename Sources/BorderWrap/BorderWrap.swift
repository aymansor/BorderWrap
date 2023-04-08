public class BorderWrap {
    private let minWidth: Int
    private let maxWidth: Int

    public init(minWidth: Int = 0, maxWidth: Int = Int.max) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
    }
    
    public func wrapBorder(around strings: String...) -> String {
        let maxLength = calculateBoxWidth(of: strings)
        let topBorder = generateBorder(characters: "─", corner1: "┌", corner2: "┐", length: maxLength)
        let bottomBorder = generateBorder(characters: "─", corner1: "└", corner2: "┘", length: maxLength)

        var output = topBorder

        for string in strings {
            // Split the input string into lines using the newline character as the separator
            let lines = string.split(separator: "\n", omittingEmptySubsequences: false)
            
            for line in lines {
                // Wrap the text in the line according to the calculated maxLength
                let wrappedLines = wrapText(String(line), maxLength: maxLength)
                
                // Concatenate left border, padded wrapped line, and right border to the output
                for wrappedLine in wrappedLines {
                    output += "│" + generatePaddedLine(wrappedLine, length: maxLength) + "│\n"
                }
            }
        }

        output += bottomBorder
        return output
    }

    private func calculateBoxWidth(of strings: [String]) -> Int {
        // Find the maximum length among the input strings
        let maxLength = strings.reduce(0) { max($0, $1.count) }

        // Ensure the calculated box width is within the minWidth and maxWidth bounds
        // Make sure the width is not smaller than minWidth
        let boundedWidth = max(minWidth, maxLength)
        // Make sure the width is not larger than maxWidth
        let finalWidth = min(boundedWidth, maxWidth)

        return finalWidth
    }

    private func generateBorder(characters: String, corner1: String, corner2: String, length: Int) -> String {
        return corner1 + String(repeating: characters, count: length) + corner2 + "\n"
    }

    private func wrapText(_ text: String, maxLength: Int) -> [String] {
        let words = text.split(separator: " ")
        var wrappedLines: [String] = []
        var line = ""

        for word in words {
            // If the word length exceeds maxLength, split the word into smaller parts
            if word.count > maxLength {
                let splitWord = splitLongWord(String(word), maxLength: maxLength)
                for subword in splitWord {
                    if !line.isEmpty && line.count + subword.count + 1 <= maxLength {
                        line += " "
                    } else {
                        wrappedLines.append(line)
                        line = ""
                    }
                    line += subword
                }
            } else {
                // If adding the word to the current line would exceed maxLength, start a new line
                if line.count + word.count + 1 > maxLength {
                    wrappedLines.append(line)
                    line = ""
                }

                // Add the word to the current line, with a space if the line is not empty
                if !line.isEmpty {
                    line += " "
                }
                line += word
            }
        }
        // Append the last line to the wrapped lines array
        wrappedLines.append(line)

        return wrappedLines
    }
    
    private func splitLongWord(_ word: String, maxLength: Int) -> [String] {
        var result: [String] = []
        var startIndex = word.startIndex

        // Continue splitting the word until the entire word is processed
        while startIndex < word.endIndex {
            // Calculate the endIndex based on the maxLength
            let endIndex = word.index(startIndex, offsetBy: maxLength - 1, limitedBy: word.endIndex) ?? word.endIndex
            // Get the substring from startIndex to endIndex
            let subword = word[startIndex..<endIndex]

            // Append the substring and a hyphen to the result array if there's more text to process
            if endIndex < word.endIndex {
                result.append(String(subword) + "-")
            } else {
                result.append(String(subword))
            }

            // Update the startIndex for the next iteration
            startIndex = endIndex
        }
        return result
    }

    private func generatePaddedLine(_ line: String, length: Int) -> String {
        // // Calculate the amount of padding required on each side of the line
        let paddingLength = (length - line.count) / 2
        let leftPadding = String(repeating: " ", count: paddingLength)
        let rightPadding = String(repeating: " ", count: length - line.count - paddingLength)
        return "\(leftPadding)\(line)\(rightPadding)"
    }
}
