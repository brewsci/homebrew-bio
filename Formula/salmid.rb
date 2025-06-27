class Salmid < Formula
  desc "Rapid confirmation of Salmonella species from WGS"
  homepage "https://github.com/hcdenbakker/SalmID"
  url "https://github.com/hcdenbakker/SalmID/archive/0.1.23.tar.gz"
  sha256 "aadcee6a7ba87ff4681129e86238d5edb7617dc4adf291e651b05ccb6d450cc9"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "259fc770fe9540514d125b042b296e983e91f8466cf7732959f7d6e695b4f245"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c8b74c883ec1c0c5e83dc053ce622638d4249851ac72803e8de217eaa4d913a"
  end

  depends_on "python"

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "pip3", "install", "--prefix=#{libexec}", "."

    inreplace Dir["SalmID*py"], "#!/usr/bin/env python", "#!#{Formula["python3"].bin}/python3"
    bin.install Dir["bin/*"]
    (bin/"SalmID.py").write_env_script libexec/"bin/SalmID.py", PYTHONPATH: ENV["PYTHONPATH"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SalmID.py --version")
  end
end
