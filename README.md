
# [![AbsioSdk](logo.png)](https://www.absio.com)
# Absio Swift SDK

Absio Swift SDK is a part of Absio’s developer toolset which developers can use to build PKI-based authentication and data-level encryption directly into software applications and services, without having to manage keys and certificates, add hardware, or rely on a third-party service. 

## Basics 
General technology overview and toolset can be found [here](http://docs.absio.com/#technologytools)

## Requirements

- iOS 12.0 and higher
- macOs 10.14 and higher
- Xcode 11.7 and higher
- Swift 5 and higher

## Installation 
Currently we are supporting CocoaPods. 
If you are new to using pods please visit getting started [page](https://guides.cocoapods.org/using/getting-started.html).

To get our pod instantly please use line below

```ruby
pod 'AbsioSDK', '~> 1.0.0'
```

#### **Note:**
We are distributing fat libraries to support both simulator and different architectures. If you have any **issues with validation/submitting** your application to App Store, please insert content of [cut-architectures.sh](cut-architectures.sh) into 'Build Phases' of your application with 'New Run Script Phase'. This will strip unused architectures for simulators and validation should then go smooth.

## Getting started 
Please see the detailed instructions in our [quick start guide](http://docs.absio.com/#quickstartstart)

## Documentation
Latest documentation can be found at our docs [page](http://docs.absio.com/#technologydata)

The API reference is located at our Github [page](https://github.com/Absio/swift-absio-secured-container/).

## License
Please visit our license page at [absio.com](http://docs.absio.com/#licenselicense)

## Getting Help
- Please contact us at support@absio.com if you experience issues, want to submit feedback or have general questions about the technology

- Have a bug to report? [Open an issue](https://github.com/Absio/swift-absio-secured-container/issues). If possible, include the version of Absio SDK, a full log and description on how to reproduce.
