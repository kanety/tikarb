require 'rjb'

class Tikarb
  class Java
    class << self
      def load
        Rjb::load(Tikarb.path)

        import 'java.lang.System'
        import 'java.io.PrintStream'
        import 'java.io.FileInputStream'
        import 'java.io.ByteArrayInputStream'
        import 'java.io.ByteArrayOutputStream'
        import 'org.apache.tika.Tika'
        import 'org.apache.tika.cli.TikaCLI'
        import 'org.apache.tika.metadata.Metadata'
      end

      def import(path)
        name = path.split('.').last.to_sym
        const_set(name, Rjb::import(path)) unless const_defined?(name)
      end
    end
  end

  class << self
    attr_accessor :path

    def detect(file)
      Java.load

      tika = Java::Tika.new
      tika.detect(file_to_input_stream(file))
    end

    def parse(file)
      Java.load

      tika = Java::Tika.new
      metadata = Java::Metadata.new
      text = tika.parseToString(file_to_input_stream(file), metadata)
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

    def file_to_input_stream(file)
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
