// This is the key for accessing the ssb protocol.
module.exports =
  new Buffer('V2VsY29tZSB0byB0aGUgU2VjdXJlIFNjdXR0bGVidXR0IHR1dG9yaWFs', 'base64')

// There is nothing special about this value.
// It's just this string encoded in base64:
// "Welcome to the Secure Scuttlebutt tutorial"
//
// During the build of the Docker image, this file
// overwrites lib/ssb-cap.js in the scuttlebot source
// so we don't interfere with the default SSB social network.
