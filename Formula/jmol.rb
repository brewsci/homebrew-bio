class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.32/Jmol-14.31.32-binary.zip"
  sha256 "a63096a53388fa2e35139ec97651d4e1be1ffec9e3259e219d07b1b7e7829c52"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "5c7aa7766d2726fe4738dea9d691ea5b1b853849bbf43d37ec155790845b6116"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e85fb24aea6d643c36516c1cfc0bfe3b1bff07d13d109c8b584f70e2622a27b1"
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
