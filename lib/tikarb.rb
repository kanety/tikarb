require 'rjb'

class Tikarb
  class Java
    IMPORTS = ['java.lang.System',
               'java.io.PrintStream',
               'java.io.FileInputStream',
               'java.io.ByteArrayInputStream',
               'java.io.ByteArrayOutputStream',
               'org.apache.tika.Tika',
               'org.apache.tika.cli.TikaCLI',
               'org.apache.tika.metadata.Metadata']

    class << self
      def load
        Rjb::load(Tikarb.path)

        IMPORTS.each do |path|
          name = path.split('.').last.to_sym
          Java.const_set(name, Rjb::import(path)) unless Java.const_defined?(name)
        end
      end
    end
  end

  class << self
    attr_accessor :path

    def detect(file)
      Java.load

      tika = Java::Tika.new
      tika.detect(file_to_inputStream(file))
    end

    def parse(file)
      Java.load

      tika = Java::Tika.new
      metadata = Java::Metadata.new
      text = tika.parseToString(file_to_inputStream(file), metadata)
      return text, metadata_to_hash(metadata)
    end

    def cli(*args)
      Java.load

      trap_stdout do
        cli = Java::TikaCLI.new
        args.each { |arg| cli.process(arg) }
      end
    end

    private

    def file_to_inputStream(file)
      if file.respond_to?(:read)
        Java::ByteArrayInputStream.new(file.read)
      else
        Java::FileInputStream.new(file)
      end
    end

    def trap_stdout
      out = Java::ByteArrayOutputStream.new
      Java::System.setOut(Java::PrintStream.new(out))
      yield
      out.toString
    end

    def metadata_to_hash(metadata)
      metadata.names.each_with_object({}) do |name, hash|
        hash[name] = metadata.get(name)
      end
    end
  end
end
