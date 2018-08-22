class Verticalize < Formula
  desc "Simple tool to verticalize text delimited files"
  homepage "https://github.com/lindenb/verticalize"
  url "https://github.com/lindenb/verticalize/archive/v1.0.1.tar.gz"
  sha256 "e8aeb3e1ce0e836aa5e47ccfe75578eb96240e5d181a78396b375bc9916d331a"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "18dab9f5eea52a95c3821c7af59aa95b1e11e8de78e3a2581fb549dc080b3394" => :sierra_or_later
    sha256 "4821491790dd77a2de2a7a9c214ef326b13251f736bf730f45eb6f0c17806ab6" => :x86_64_linux
  end

  def install
    system "make"
    system "make", "test"
    bin.install "verticalize"
    man1.install "verticalize.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/verticalize -v ")
  end
end
