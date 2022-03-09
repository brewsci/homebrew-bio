class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.32/Jmol%2014.32.31/Jmol-14.32.31-binary.zip"
  sha256 "674cf10f53c1e49f64a965d99e8d0d45e0577e034df34570aaba9cf6b5f7ef3b"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "24de2b006ef39450f4eecf9714b958b7719e11abc5c56529ec90c422c9556e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0d982c20ea2feaf362ab590d1a73969f950b1dfdcb6f42a6db9ae431ca7e0d14"
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
      if ENV["HOMEBREW_GITHUB_ACTIONS"]
        assert_match "java.awt.HeadlessException",
shell_output("#{bin}/jmol -n 2>&1", 1)
      end
    end
  end
end
