class Libmuscle < Formula
  desc "C/C++ API to the muscle alignment software"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/v1.5.2.tar.gz"
  version "3.7"
  sha256 "780ddb5fd8c626bf77d31af8e620436ca942801de942c682d1f246bbbdcf2c3d"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "ce5c2cc4407aeb26bcf71f5204a9a17b8f89a239b4e903d684bbb12cbca7adda" => :sierra
    sha256 "3a22ca4f76ba8fbb704e2a8823d6d45611a3a858494580c28a6dc32f72e8345c" => :x86_64_linux
  end

  def install
    ENV.deparallelize
    cd "muscle" do
      system "./autogen.sh"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
      rm bin/"muscle"
      doc.install "AUTHORS", "ChangeLog"
    end
  end

  test do
    assert_predicate lib/"libMUSCLE-#{version}.a", :exist?
  end
end
