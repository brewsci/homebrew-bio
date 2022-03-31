class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.32/Jmol%2014.32.44/Jmol-14.32.44-binary.zip"
  sha256 "744ffed7584ea1d6b645d5a79ab6790e82307c8fdce046b84941134cb8f8a416"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "5883ea79577f80b85db5ee9be06644a141cc053c1089782756c3e1a2a173e757"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a3e945c4ab7793f86a5dd9caf4a16278725c7dca2a792e93d139e146225b6d66"
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
