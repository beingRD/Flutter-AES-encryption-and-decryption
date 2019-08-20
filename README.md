# Encryption & Decryption Flutter Plugin:
* AES 128
* AES 256
* CBC
* No Padding
* ARGON 2i
* ARGON 2d

## Plugin Definition

### First Step: 
###### Creating a plug-in project
In fact, it seems that you can also directly call the implementation of the Platform channel in the Flutter project. Considering that this part can be separated to maintain and benefit the future, you can choose to create a Plugin. 

###### First you need to create a plugin project, by the following command:
```
flutter create --org com.beingRD --template=plugin encryptions
```
This will generate a project, it is worth noting that Android will use Java here, iOS will use Objective-C. But Objective-C is too much trouble for people like me who have no foundation. I tried it and gave up. So you need to switch to Swift. 

###### There is a small way to modify only the iOS part:

```
cd encryptions
rm -rf ios examples/ios
flutter create -i swift --org com.beingRD .
```
Execute this command after deleting the ios directory, you can regenerate the iOS project, based on swift.


### Second Step:
###### Defining the Dart interface
First define the interface we want to expose. For example, for AES encrypted functions, we can write:

```
class Encryptions {
  static const MethodChannel _channel = const MethodChannel('encryptions');

  static Future<Uint8List> aesEncrypt(
      Uint8List key, Uint8List iv, Uint8List value) async {
    return await _channel
        .invokeMethod("aesEncrypt", {"key": key, "iv": iv, "value": value});
  }
  ```

## Note:

The **MethodChannel** is used to call the native interface, and each platform will register a **MethodChannel** with the same name. The native method is called by the method name + parameter, and the corresponding list of parameters can be found in the official documentation. Here we want the `<byte[]>` type in Java, so use `<Uint8List>`
The parameter is passed to the native interface via the key-value map, and the native code gets the parameter value by parameter name.

## Platform implementation

### For iOS platform
###### First you need to build it first:

```
cd encryptions/example; 
flutter build ios --no-codesign
```

Open the project in Xcode, there is a `<SwiftEncryptionsPlugin.class>`, which can be implemented in this:

```
public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! [String: Any];
    switch call.method {
    case "aesEncrypt", "aesDecrypt":
        let key = args["key"] as! FlutterStandardTypedData;
        let iv = args["iv"] as! FlutterStandardTypedData;
        let value = args["value"] as! FlutterStandardTypedData;
        
        do {
            let cipher = try handleAes(key: key.data, iv: iv.data, value: value.data, method: call.method);
            result(cipher);
        } catch {
            result(nil);
        };     
        // ...
    }
}
```

Because you need to use **Argon2**, you need to call the c native code in swift, try some methods will not work, and later found that it is actually relatively simple, directly in the Supported Files there is a reference to the 
`<encryptions-umbrella.h>` file, you can directly call:

```
#import "EncryptionsPlugin.h"
#import "argon2.h"
func argon2i(password: Data, salt: Data)-> Data {
    var outputBytes  = [UInt8](repeating: 0, count: hashLength);
    
    password.withUnsafeBytes { passwordBytes in
        salt.withUnsafeBytes {
            saltBytes in
            argon2i_hash_raw(iterations, memory, parallelism, passwordBytes, password.count, saltBytes, salt.count, &outputBytes, hashLength);
        }
    }
    
    return Data(bytes: UnsafePointer<UInt8>(outputBytes), count: hashLength);
}
```

### For Android platform
Open the project in Android Studio. For the first time you need to build `<cd encryptions/example>`; flutter build apk, the iOS is similar). Android implementation will be a bit simpler, here only talk about how to call c native code:

First add extra steps to `<build.gradle>`:
```
externalNativeBuild {
    cmake {
        path "src/main/cpp/CMakeLists.txt"
    }
}
```
Then specify the compilation step in `<CMakeLists.txt>`, I need to compile a library of **argon2**, and a library called by **JNI**.

```
add_library(
        argon2
        SHARED

        argon2/src/argon2.c
        argon2/src/core.c
        argon2/src/blake2/blake2b.c
        argon2/src/encoding.c
        argon2/src/ref.c
        argon2/src/thread.c
)

add_library(
        argon2-binding
        SHARED

        argon2_binding.cpp
)

target_include_directories(
        argon2
        PRIVATE
        argon2/include
)

target_include_directories(
        argon2-binding
        PRIVATE
        argon2/include
)

find_library(
        log-lib
        log)


target_link_libraries(
        native-lib
        ${log-lib})

target_link_libraries(
        argon2-binding

        argon2
        ${log-lib})
Then call the method of argon2 via JNI:

public final class Argon2 {
    static {
        System.loadLibrary("argon2-binding");
    }
    
    // ...

    private native byte[] argon2iInternal(int iterations, int memory, int parallelism, final byte[] password, final byte[] salt, int hashLength);

    private native byte[] argon2dInternal(int iterations, int memory, int parallelism, final byte[] password, final byte[] salt, int hashLength);
}
```
The detailed code is no longer exhaustive.

## Example
In the example project, call these interfaces with dart, and then run them in **Xcode** and **Android Studio** respectively to see if they are supported by different platforms. It is not clear if there is an automated test method.


A new flutter plugin project.


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
