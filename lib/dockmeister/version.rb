module Dockmeister

  module Version

    MAJOR = 0
    MINOR = 4
    TINY  = 1

    STRING = [MAJOR, MINOR, TINY].join(".")

  end

  VERSION = ::Dockmeister::Version::STRING

end
