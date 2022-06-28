class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.32/Jmol%2014.32.61/Jmol-14.32.61-binary.zip"
  sha256 "c25eafef65ee52c2af70f95405c52e795ecb5bcb7bb0acd166af6cb27849f470"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ccfdead4dcb16171e37618c42d74d33c1eb1db09272706e425dbeb3fc56b50eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99580c3fd53aa41c25a6a5c971c22ca31fe852e6b0f875958578050501cfe157"
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
    assert_match version.to_s, shell_output("#{bin}/jmol -n") if OS.mac?

    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      # unfortunately, the application can not be run headless
      assert_match "java.awt.HeadlessException",
shell_output("#{bin}/jmol -n 2>&1", 1)
    end
  end
end
