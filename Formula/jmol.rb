class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.26/Jmol-14.31.26-binary.tar.gz"
  sha256 "23052a17b3f1df78772ba46e4625beec210f82d33f2a2719bd7b55ece513b6ea"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "abf385853b30268a9f95a3e0c800868b2013365fc1c8f0bf3225cf30b3a31cbe" => :catalina
    sha256 "dde8708c4956f21620e20fc52c80cab44477db2239228ee1b3b77a7893957644" => :x86_64_linux
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
    on_macos do
      assert_match version.to_s, shell_output("#{bin}/jmol -n")
    end

    on_linux do
      # unfortunately, the application can not be run headless
      assert_match "java.awt.HeadlessException", shell_output("#{bin}/jmol -n 2>&1", 1) if ENV["CI"]
    end
  end
end
