# --------------------------------------------------------------
# mips_tester Ruby gem. https://github.com/razielgn/mips_tester
# Author: Federico Ravasio, razielgn
#
# Modified by Aris Efthymiou
# for use in MYY402, Computer Architecture course
# at University of Ioannina, Comp. Science and Engineering
# --------------------------------------------------------------

require 'tempfile' unless defined? Tempfile
require 'open3'

# Main MIPSTester module
module MIPSTester
  # Library version
  VERSION = "0.1.5"
  
  # MIPSFileError Exception, raised when test file is not valid or non-existent
  class MIPSFileError < Exception; end
  
  # MIPSInvalidBlockError Exception, raised when no block is given to test method
  class MIPSInvalidBlockError < Exception; end
  
  # MIPSMarsError Exception, raised when MARS installation path is not valid.
  class MIPSMarsError < Exception; end
  
  # Main MIPS tester class.
  # It provides the methods to test MIPS ASMs files
  class MIPS
    # Register validation
    REGISTER_REGEX = /^(at|v[01]|a[0-3]|s[0-7]|t\d|[2-9]|1[0-9]|2[0-5])$/
    
    # Memory address validation
    ADDRESS_REGEX = /^0x[\da-f]{8}$/
    
    # MARS jar path
    attr_reader :mars_path
    
    # Create a new MIPSTester::MIPS object
    #
    # @example
    #   MIPSTester::MIPS.new :mars_path => 'path/to/mars.jar'
    #
    # @return [MIPSTester::MIPS] The MIPSTester::MIPS object 
    def initialize(params = {})
      @mars_path = params.delete(:mars_path)
      raise MIPSMarsError.new("Provide valid Mars jar.") if not @mars_path or not File.exists? @mars_path
    end
  
    # Run a given file in the emulator. *A provided block is mandatory*, with starter registers
    # and expected values.
    # A simple DSL is provided:
    # * set [Hash] => set initial registers or memory addresses
    # * expect [Hash] => expect values of registers or memory addresses
    # * verbose! => optional, if given prints on STDOUT set registers and expected ones
    #
    # @example
    #   test "file.asm" do
    #     set :s1 => 6, '0x10010000' => 0xFF
    #     expect :s5 => 6
    #     verbose!
    #   end
    #
    # @param file [String] The path to the file to run
    # @param block The block to provide info on what to test
    #
    # @return [Boolean] True if the test went well, False if not.
    def test(file, &block)
      raise MIPSFileError.new("Provide valid file.") if not file or not File.exists? file
      raise MIPSInvalidBlockError.new("Provide block.") if not block
    
      reset!
  
      instance_eval(&block)
    
=begin
	  # razielgn's method of initializing register and memory
	  #    It doesn't work for Aris:
	  #   - I want programs to start from "main"
	  #   - I don't know the mem addresses to modify. We use labels.
      asm = Tempfile.new "temp.asm"
      asm.write prep_params if block
      asm.write File.read(file)
      asm.close
    
	 # Aris: Modify Mars arguments.
	 #   - start from "main"
	 #   - output in hexadecimal
	 #   - separate stderr output
     cli = `#{["java -jar",
               @mars_path,
               @exp_regs.empty? ? "" : @exp_regs.keys.join(" "), 
               @exp_addresses.empty? ? "" : @exp_addresses.map{|addr| "#{addr[0]}-#{addr[0].to_i 16}"}.join(" "),
               " nc ic sm ",
               asm.path].join(" ")}`
=end

	  mem_addr = @exp_addresses.empty? ? "" : @exp_addresses.map{|addr| "#{addr[0]}-#{addr[0].to_i 16}"}.join(" ")
      so, cli, status = Open3.capture3("java -jar #{@mars_path} #{@exp_regs.keys.join(" ")} #{mem_addr} nc sm me #{file}");
      
#      begin
        results = parse_results cli

		# Aris: Output normal application output
		puts so;
        
        puts "Expected:\n#{@exp_regs.dup.merge @exp_addresses}\nResults:\n#{results}" if @verbose
        
        return compare_hashes(@exp_regs.dup.merge(@exp_addresses), results)
=begin
      # Aris: don't need this
      rescue Exception => ex
        raise MIPSFileError.new ex.message.gsub(asm.path, File.basename(file)).split("\n")[0..1].join("\n")
      ensure
        asm.unlink
      end
=end
    end
  
    private
    
    def verbose!; @verbose = true; end
    
    def set hash
      hash.each_pair do |key, value|
        case key.to_s
          when REGISTER_REGEX then @set_regs.merge! key => value
          when ADDRESS_REGEX then @set_addresses.merge! key => value
          else puts "Warning: #{key.inspect} not recognized as register or memory address. Discarded."
        end
      end
    end
    
    def expect hash
      hash.each_pair do |key, value|
        case key.to_s
          when REGISTER_REGEX then @exp_regs.merge! key => value
          when ADDRESS_REGEX then @exp_addresses.merge! key => value
          else puts "Warning: #{key.inspect} not recognized as register or memory address. Discarded."
        end
      end
    end
    
    def reset!
      @set_regs = {}
      @set_addresses = {}
      @exp_regs = {}
      @exp_addresses = {}
      @verbose = false
    end
  
    def parse_results(results)
      raise Exception.new "Error in given file!\nReason: #{results}\n\n" if results =~ /^Error/
      
      out = {}
      
      results.split("\n")[1..-1].each do |reg|
        key, value = reg.strip.split("\t")
        
        if key =~ /^Mem/
          out.merge! key[4..-2] => value.to_i(16)
        else
          out.merge! key[1..-1] => value.to_i(16)
        end
      end
      
      out
    end
  
=begin
    # Aris: We don't set register, mem.
    def prep_params
      out = ""
      @set_regs.each_pair {|key, value| out << "li\t\t$#{key}, #{value}\n" }
      @set_addresses.each_pair do |key, value|
        out << "li\t\t$t0, #{key}\n"
        out << "li\t\t$t1, 0x#{value.to_s(16)}\n"
        out << "sb\t\t$t1, ($t0)\n"
      end
      
      out
    end
=end
    
    def compare_hashes(first, second)
      first.each_pair do |key, value|
        return false unless second[key.to_s] == value
      end
      
      true
    end
  end
end
