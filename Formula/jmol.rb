class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.32/Jmol%2014.32.9/Jmol-14.32.9-binary.zip"
  sha256 "b21b6752717a6f560445f989ca31117dbbcd79c4941cd1abd5e8b6eeb18e97a8"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "86c3fc4932620833216a93c56a726616586df523f7d5725a8c62269b315a6a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be71f8cf15288155cc33ebd2a9484bdaeae938bff05ffde7cc3f722984cef0d8"
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
