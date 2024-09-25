# Add Kerberos and DSA key support to openssh package
# Needed to solve issues with following ssh configuration
#        GSSAPIAuthentication yes
#        GSSAPIDelegateCredentials no
#        GSSAPIKeyExchange yes
(self: super: {
  openssh = super.openssh.override {
    withKerberos = true;
    dsaKeysSupport = true;
  };
})
