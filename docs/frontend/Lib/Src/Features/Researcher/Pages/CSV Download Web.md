# download_csv_web.dart

## Overview

This file implements the **web-specific CSV download utility** used in Flutter web builds. It converts a CSV string into a downloadable file by creating a browser `Blob`, generating an object URL, and programmatically triggering a download via an anchor element.

File: `download_csv_web.dart`

## Architecture / Design

The implementation relies on the `package:web` library and Dart JS interop to interact with browser APIs.

Process flow:

1. Convert CSV string → UTF-8 bytes
2. Create a browser `Blob` with MIME type `text/csv`
3. Generate an object URL with `URL.createObjectURL`
4. Create a temporary `<a>` element
5. Set:

   * `href` → generated URL
   * `download` → filename
6. Trigger `anchor.click()` to start the download
7. Revoke the object URL to free memory

This approach avoids server-side file generation and works entirely in the browser.

## Configuration

Function signature:

```
void downloadCsvFile(String csv, String filename)
```

Parameters:

* **csv** — The CSV file contents as a string.
* **filename** — The name of the file that will be downloaded by the browser.

The MIME type used for the generated file is:

```
text/csv
```

## API Reference

### Function

`downloadCsvFile(String csv, String filename)`

Behavior:

* Encodes the CSV string using UTF-8
* Creates a browser `Blob` from the encoded bytes
* Generates an object URL for the blob
* Creates a temporary anchor element (`HTMLAnchorElement`)
* Sets the download filename
* Programmatically clicks the anchor to start the download
* Revokes the object URL after triggering the download

## Error Handling

This function does not implement explicit error handling.

Potential issues include:

* Running outside a **Flutter web environment** (browser APIs unavailable)
* Browser security restrictions blocking automatic downloads
* Invalid CSV string input (will still download but may produce malformed CSV)

## Usage Examples

Basic usage:

```
final csvData = '''
Name,Age
Alice,30
Bob,25
''';

downloadCsvFile(csvData, 'participants.csv');
```

Example within a Flutter action:

```
ElevatedButton(
  onPressed: () {
    downloadCsvFile(csvString, 'export.csv');
  },
  child: const Text('Download CSV'),
)
```

## Related Files

* Flutter platform-specific implementations (if present) for non-web environments.
* CSV generation utilities that build the CSV string before calling this function.
