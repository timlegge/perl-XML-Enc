use strict;
use warnings;
use Test::More tests => 40;
use XML::Enc;
use MIME::Base64 qw/decode_base64/;
use File::Which;
use File::Slurper qw/read_text/;

my $plaintext = <<'UNENCRYPTED';
<?xml version="1.0" encoding="utf-8" ?>
<PayInfo>
  <Name>John Smith</Name>
  <CreditCard Limit='2,000' Currency='USD'>
    <Number>1076 2478 0678 5589</Number>
    <Issuer>CitiBank</Issuer>
    <Expiration>06/10</Expiration>
  </CreditCard>
</PayInfo>
UNENCRYPTED

my @key_methods     = qw/rsa-1_5 rsa-oaep-mgf1p/;
my @data_methods    = qw/aes128-cbc aes192-cbc aes256-cbc tripledes-cbc/;

my %sesskey = (
                'aes128-cbc'    => 'aes-128',
                'aes192-cbc'    => 'aes-192',
                'aes256-cbc'    => 'aes-256',
                'tripledes-cbc' => 'des-192',
            );

foreach my $km (@key_methods) {
    foreach my $dm (@data_methods) {

        my $element_tmpl = <<"ELEMENT";
<?xml version="1.0" encoding="UTF-8"?>
<!--
XML Security Library example: Original XML
 doc file before encryption (encrypt3 example).
-->
<EncryptedData
  xmlns="http://www.w3.org/2001/04/xmlenc#"
  Type="http://www.w3.org/2001/04/xmlenc#Element">
 <EncryptionMethod Algorithm=
   "http://www.w3.org/2001/04/xmlenc#$dm"/>
 <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
  <EncryptedKey xmlns="http://www.w3.org/2001/04/xmlenc#">
   <EncryptionMethod Algorithm=
     "http://www.w3.org/2001/04/xmlenc#$km"/>
   <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
    <KeyName/>
   </KeyInfo>
   <CipherData>
    <CipherValue/>
   </CipherData>
  </EncryptedKey>
 </KeyInfo>
 <CipherData>
  <CipherValue/>
 </CipherData>
</EncryptedData>
ELEMENT

my $content_tmpl = <<"CONTENT";
<?xml version="1.0" encoding="UTF-8"?>
<!--
XML Security Library example: Original XML
 doc file before encryption (encrypt3 example).
-->
<EncryptedData
  xmlns="http://www.w3.org/2001/04/xmlenc#"
  Type="http://www.w3.org/2001/04/xmlenc#Element">
 <EncryptionMethod Algorithm=
   "http://www.w3.org/2001/04/xmlenc#$dm"/>
 <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
  <EncryptedKey xmlns="http://www.w3.org/2001/04/xmlenc#">
   <EncryptionMethod Algorithm=
     "http://www.w3.org/2001/04/xmlenc#$km"/>
   <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
    <KeyName/>
   </KeyInfo>
   <CipherData>
    <CipherValue/>
   </CipherData>
  </EncryptedKey>
 </KeyInfo>
 <CipherData>
  <CipherValue/>
 </CipherData>
</EncryptedData>
CONTENT

SKIP: {
            skip "xmlsec1 not installed", 5 unless which('xmlsec1');

            ok( open XML, '>', 'plaintext.xml' );
            print XML $plaintext;
            close XML;

            ok( open ELEMENT, '>', 'element_tmpl.xml' );
            print ELEMENT $element_tmpl;
            close ELEMENT;

            # Encrypt using xmlsec
            my $encrypt_response = `xmlsec1 encrypt --pubkey-cert-pem t/sign-certonly.pem --session-key $sesskey{$dm} --xml-data plaintext.xml --output encrypted-element.xml element_tmpl.xml 2>&1`;

            my $encrypted = read_text('encrypted-element.xml');

            unlink 'element_tmpl.xml';
            unlink 'encrypted-element.xml';

            my $decrypter = XML::Enc->new(
                        {
                            key                 => 't/sign-private.pem',
                            no_xml_declaration  => 1
                        }
            );

            # Decrypt using XML::Enc
            ok($decrypter->decrypt($encrypted) =~ /1076 2478 0678 5589/,
                    "Decrypted xmlsec1 $dm $km Element");

            # Test Encrypted Content
            ok( open CONTENT, '>', 'content-template.xml' );
            print CONTENT $content_tmpl;
            close CONTENT;

            $encrypt_response = `xmlsec1 encrypt --pubkey-cert-pem t/sign-certonly.pem   --session-key $sesskey{$dm} --xml-data plaintext.xml --output encrypted-content.xml --node-xpath '/PayInfo/CreditCard/Number/text()' content-template.xml 2>&1`;

            $encrypted = read_text('encrypted-content.xml');

            unlink 'plaintext.xml';
            unlink 'content-template.xml';
            unlink 'encrypted-content.xml';

            $decrypter->{force_element_to_content} = 1;
            # Decrypt using XML::Enc
            ok($decrypter->decrypt($encrypted) =~ /1076 2478 0678 5589/,
                    "Decrypted $dm $km xmlsec1 Content");
        }
    }
}
done_testing;
