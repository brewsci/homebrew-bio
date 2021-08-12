class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.51/Jmol-14.31.51-binary.zip"
  sha256 "693f64fd6a491e5c9e45825a4470c46cc6fa84db98af57a4e27247d8d9c00ca9"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "6f18b45fa5c2917798bcf80f1885053d398c321f496385de7d10a81ca23d4f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4b06c6371e4fadfd0cb6a6d03e8ca77eecf43b924e73a17fd405879329d9eab"
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
