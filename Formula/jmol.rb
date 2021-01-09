class Jmol < Formula
  desc "An open-source Java viewer for chemical structures in 3D."
  homepage "http://jmol.sourceforge.net/"
  license "LGPL 2.0"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.2/Jmol-14.31.2-binary.zip"
  version "14.31.2"
  sha256 "5a574b7e9b74d3bee5573bc9342a6ab1cdb849cbf08e81ac084e11cfb8721cae"

  head do
    url "https://svn.code.sf.net/p/jmol/code/trunk/Jmol"
    depends_on "ant" => :build
  end

  depends_on "openjdk"

  def install
    system "ant" if build.head?
    (bin/"jmol").write <<~EOS
      #!/bin/sh
      JMOL_HOME=#{prefix} exec #{prefix}/jmol.sh "$*"
    EOS
    chmod 0755, "jmol.sh"
    prefix.install "jmol.sh", Dir["*.jar"]
    prefix.install Dir["build/*.jar"] if build.head?
  end

  test do
    # unfortunately, the application can not be run headless
    # (throws java.awt.HeadlessException), but this should work otherwise
    system "jmol", "-n"
  end
end
