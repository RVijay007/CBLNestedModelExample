### BACKGROUND

This is an example project for using Nested JSON Objects in CBLModels for the Couchbase-lite frameworks. By using the new CBLNestedModel classes, we can generate Couchbase documents with the following structure. In particular, notice the N-Depth level JSON format that we can now create with classes, and the usage of NSDictionaries with model objects as their values.

```
 {
 "my-sync-db": {
    "users": {
        "GUEST": {
            "admin_channels": [
            "public"
            ],
            "disabled": false
        }
    },
    "bucket": "my-remote-bucket",
    "server": "http://localhost:8091",
    "sync": "function(doc) {channel(doc.channels);}"
    }
 }
```

### INSTALLATION

1.  Clone the repository to your local drive
2.  Run ```git submodule update --init --recursive``` at the top level of your cloned repository

### USAGE

The AppDelegate provides 2 methods for testing. You can enable / disable these tests by commenting out the appropriate line in the ```applicationDidFinishLaunching:``` method.

**jsonEncodingTest** - illustrates an issue with the current CBLJSONEncoding paradigm. This is commented out since it is not directly relevant to the example.

**nestedModelTest** - Produces a nested model of classes that will save to a single document in the Couchbase-Lite NoSQL store. It produces the JSON output above. 

Run the app, and once the window appears you can close the app. Locate the ```.cblite``` database in ~/Library/Application Support/com.rvijay007.CBLNestedModelExample and open it in the CouchbaseLite View app to see the documents within. You can breakpoint at various lines within the nestedModelTest and check out the cblite database to see changes as they are being made.

### License

CBLNestedModelExample is available under the MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
