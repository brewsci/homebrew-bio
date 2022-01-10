class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.32/Jmol%2014.32.10/Jmol-14.32.10-binary.zip"
  sha256 "a7d0d1f16dcd740108eb1bb4c653cd31597085cd616455463fc22cb85f12e74e"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "fbbb8c9d82d2d3c750f25b99bcac0ece1eb7c498c286fb88f6cc04bd09f5f79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7cb98b8a2cddebfd80becde27d315a326fe26e9d05cd2951485bb41277cfcfc"
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
