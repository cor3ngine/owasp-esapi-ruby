require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

##############
#
#  Validator Rspec
# Validation checks that a given input is valid, as as part of the request
# canicolize the input f requested to check if an item is not only valid but also return the valid input
# validator, under the covers should use the codec configuration to process underlying encodings
# example:
# given input string my&lt;script%20alert('test')%20/&gt;value
# it canicalization is requested should be first decoded
# so the input becomes my<script alert('test')/>value BEFORE any validation tests are processed
# This more generic method means it can be applied to ANY input and doesnt require specific sub classing
# to handle different classes of string. We apply rules equally on all input going into the application
# contining the example
#  Owasp::Esapi::Validator.get_valid_input(context,input,type,maxlen,allowNull,canonicalize)
# would raise a ValidatorError or IntrustionError
# IntrustionError in this case could be generated by the value encoder during canonicalization

module Owasp
  module Esapi
    module Validator
      describe Validator do
        let(:validator) { Owasp::Esapi::Validator}
        let(:allow_null) { false }
        it "should load my validator rules" do
          Owasp::Esapi.load_config("path to my config")
          validator.rule_set.include?("Project.Safe.String")
        end

        # Valid dates are dates that can be
        # interrupted as real date numbers
        it "should validate my date" do
          date = '2010-13-02'
          validator.get_valid_date("Date input #{date}",date,format,allow_null)
          validator.is_valid_date("Date input #{date}",date,format,allow_null)
        end

        # Valid credit card is any card number that passes
        # the check digit check
        it "should validate my credit card number" do
          amex = '378282246310005'
          mc = '5105105105105100'
          visa = '4111111111111111'
          validator.get_valid_credit_card("Credit card #{credit}",amex,allow_null)
          validator.is_valid_credit_card("Credit card #{credit}",vis,allow_null)
        end

        # Validates the request contains the required parameters for a given request
        # and any optional ones indicated
        it "should validate my http request parameters" do
          parms = { :name => :required, :date=>:required, :age=>:optional}
          input = { :name=>"joe",:age=>"15",:date=>'2010-03-11'}
          validator.is_valid_http_params("HTTP Request check #{parms}",parms,input,allow_null)
          validator.get_valid_http_params("HTTP Request check #{parms}",parms,input,allow_null)
        end

        # escape and properly encode a URI and be safe of css
        it "should validate my uri" do
          uri = "http://www.google.com/my/path"
          validator.is_valid_uri("URI check #{uri}",uri,allow_null)
          validator.get_valid_uri("URI check #{uri}",uri,allow_null)
        end

        # Should be safe html that is free of scripts/css/attributes/urls/dom manipulation
        it "should validate my html is safe" do
          html = "<head><body>test</body></html>"
          max_len = 50
          validator.is_fase_html("HTML",html,max_len,allow_null)
          validator.get_safe_html("HTML",html,max_len,allow_null)
        end

        # validte a path on the host
        it "should validate my direcroty path" do
          path = "/my/path"
          root = "/my"
          validator.is_valid_directory("PATH",path,root,allow_null)
          validator.get_valid_directory("PATH",path,root,allow_null)
        end

        # validate the filename os valid
        it "should validate my filename" do
          file = "myfile"
          validator.is_valid_filename("File name #{file}",file,allow_null)
          validator.get_valid_filename("File name #{file}",file,allow_null)
        end

        # validate a number in between a min and max
        it "should validate my number" do
          number = 1.0
          min = 0
          max = 100
          validator.is_valid_number("Number #{number}",number,min,max,allow_null)
          validator.get_valid_number("Number #{number}",number,min,max_allow_null)
        end

        # check the file contents are valid in the expected encoding, check length
        # run virus scanner
        it "should validate my file contents" do
          file = "myFile"
          mime = "image/*"
          max_len = 100
          validator.is_valid_file_contents("File Contents #{file}",file,mime,max_len)
          validator.get_valid_file_contents("File Contents #{file}",file,mime,max_len)
        end

        # validate the path, name and contents
        it "should validate my fle upload" do
          file = "test"
          mime = "image/*"
          max_len = 50
          validator.is_valid_upload("Upload #{file}",file,mime,max_len,allow_null)
          validator.get_valid_upload("Upload #{file}",file,mime,max_len,allow_null)
        end

        # validate the choice is in a given lsit
        it "should validate my list items" do
          list = [:a,:b,:c]
          input = :a
          validator.is_valid_choice("Choice list",input,list,allow_null)
          validator.get_valid_choice("Choice list",input,list,allow_null)
        end

        # validate the input doesnt contain any non printable characters
        it "should validate my input is printable" do
          input = "ABCDEFGHIJKLMNOP"
          max = 50
          validator.is_valid_printable("Input of some printables",input,max,allow_null)
          validator.get_valid_printable("Input of some printables",input,max,allow_null)
        end

        # Validate the redirection URI is properly encoded
        it "should validate my redirection" do
          validator.is_valid_redirection("Login redirect",path,allow_null)
          validator.get_valid_redirection("Login redirect",path,allow_null)
        end

        # Validate some input based on params
        it "should validate my input" do
          input = "bogus"
          input_type = "InputRule"
          canonicalize = true
          max_len = 50
          validator.is_valid_input("Login user name",input,input_type,max_len,allow_null,canonicalize)
          validator.get_valid_input("Login user name",input,input_type,max_len,allow_null,canonicalize)
        end

      end
    end
  end
end