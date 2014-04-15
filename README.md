#### BACKGROUND

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

#### INSTALLATION

1.  Clone the repository to your local drive
2.  Run ```git submodule update --init --recursive``` at the top level of your cloned repository

#### USAGE

The AppDelegate provides 2 methods for testing. You can enable / disable these tests by commenting out the appropriate line in the ```applicationDidFinishLaunching:``` method.

**jsonEncodingTest** - illustrates an issue with the current CBLJSONEncoding paradigm. This is commented out since it is not directly relevant to the example.

**nestedModelTest** - Produces a nested model of classes that will save to a single document in the Couchbase-Lite NoSQL store. It produces the JSON output above. 

Run the app, and once the window appears you can close the app. Locate the cblite database in ~/Library/Application Support/com.rvijay007.CBLNestedModelExample and open it in the CouchbaseLite View app to see the documents within. You can breakpoint at various lines within the nestedModelTest and check out the cblite database to see changes as they are being made.
