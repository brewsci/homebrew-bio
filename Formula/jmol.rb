class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.25/Jmol-14.31.25-binary.zip"
  sha256 "4e3b85909421d188d72bbcf906c2276c0b7da80e52bf56b2b4f5805866baaa05"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d020951d5998754f470349628a43d786ed184a756429283f4c11340d5e5427d1" => :catalina
    sha256 "60347d4d3849260c8d921e6e5da181ce9c3bc36b7bb9cad2ad8ea9b785f9c166" => :x86_64_linux
  end

  head do
    url "https://svn.code.sf.net/p/jmol/code/trunk/Jmol"
    depends_on "ant" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "ant"
      libexec.install Dir["build/*.jar"]
    else
      libexec.install Dir["*.jar"]
    end
    chmod 0755, "jmol.sh"
    bin.install "jmol.sh" => "jmol"
    env = {
      JMOL_HOME: libexec,
      JAVA_HOME: Formula["openjdk"].opt_prefix,
      PATH:      "#{Formula["openjdk"].opt_bin}:$PATH",
    }
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    # unfortunately, the application can not be run headless
    # (throws java.awt.HeadlessException)
    assert_predicate bin/"jmol", :exist?
  end
end
