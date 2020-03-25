class Circos < Formula
  # cite Krzywinski_2009: "https://doi.org/10.1101/gr.092759.109"
  desc "Visualize data in a circular layout"
  homepage "http://circos.ca"
  url "http://circos.ca/distribution/circos-0.69-9.tgz"
  sha256 "34d8d7ebebf3f553d62820f8f4a0a57814b610341f836b4740c46c3057f789d2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "8ec9ce8fecc82d9e246675d79b172465eed074547d71ff8f85fc3f9e442b0bfe" => :sierra
    sha256 "5e67e2246fe7e5135f6ccd0f6f51c1eb2e2ee1bbd9986979889881d7c7b33107" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"

  uses_from_macos "perl"

  def install
    rm "bin/circos.exe"
    libexec.install Dir["*"]

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    unless OS.mac?
      system "cpanm", "--self-contained", "-l", libexec,
        "Clone", "List::MoreUtils", "Math::Round", "Params::Validate", "Regexp::Common"
    end
    system "cpanm", "--self-contained", "-l", libexec,
      "Config::General", "Font::TTF::Font", "GD", "Math::Bezier",
      "Math::VecStat", "Number::Format", "Readonly", "SVG", "Set::IntSpan",
      "Statistics::Basic", "Text::Format"

    (bin/"circos").write_env_script("#{libexec}/bin/circos", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"circos", "-conf", libexec/"example/etc/circos.conf", "-debug_group", "summary,timer"
    assert_predicate testpath/"circos.png", :exist?
    assert_predicate testpath/"circos.svg", :exist?
  end
end
