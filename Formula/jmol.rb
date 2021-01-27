class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.27/Jmol-14.31.27-binary.zip"
  sha256 "cabe6cb17496cbfde5b5c3969d6a7a5208f4e66fd14d5bfdd8507e4c4402aecd"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f5e2e316ed4bfbf26f037e8af28217bb261e4894ee9ab19609971fb2cc9cc518" => :catalina
    sha256 "62f69c7dc995d3048810e9417cf63c692504a7f6bef0cd990792f5a24ec51ec8" => :x86_64_linux
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
