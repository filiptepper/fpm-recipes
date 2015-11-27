class JRuby < FPM::Cookery::Recipe
  description "The Ruby Programming Language on the JVM"

  name       "jruby"
  version    "9.0.4.0"
  revision   0
  homepage   "http://www.jruby.org/"
  source     "https://s3.amazonaws.com/jruby.org/downloads/#{version}/jruby-bin-#{version}.tar.gz"
  md5        "645bf4a1dcde3f19dc0fff75c8b4b685"
  arch       "all"
  license    "EPL 1.0 / GPL 2 / LGPL 2.1"
  maintainer "Filip Tepper <filip@tepper.pl>"

  section    "interpreters"

  java = %w[
    default-jre
    default-jre-headless
    openjdk-6-jdk
    openjdk-6-jre
    openjdk-6-jre-headless
    oracle-java6-installer
    openjdk-7-jdk
    openjdk-7-jre
    openjdk-7-jre-headless
    oracle-java7-installer
    openjdk-8-jdk
    openjdk-8-jre
    openjdk-8-jre-headless
    oracle-java8-installer
  ]

  depends java.join(" | ")

  def build
    rm Dir["bin/*.{bat,dll,exe}"], :verbose => true
    rm_rf %w{docs samples share tool}, :verbose => true
  end

  def install
    prefix("jruby-#{version}").install Dir["*"]

    with_trueprefix do
      File.open(builddir("post-install"), "w", 0755) do |f|
        f.write <<-__POSTINST
#!/bin/sh
set -e

BIN_PATH="#{prefix("jruby-#{version}/bin")}"

for bin in ruby irb gem rubyc; do
  update-alternatives --install /usr/bin/$bin $bin $BIN_PATH/j$bin 20000
done

exit 0
        __POSTINST
        self.class.post_install File.expand_path(f.path)
      end

      File.open(builddir("pre-uninstall"), "w", 0755) do |f|
        f.write <<-__PRERM
#!/bin/sh
set -e

BIN_PATH="#{prefix("jruby-#{version}/bin")}"

if [ "$1" != "upgrade" ]; then
  for bin in ruby irb gem rubyc; do
    update-alternatives --remove $bin $BIN_PATH/j$bin
  done
fi

exit 0
        __PRERM
        self.class.pre_uninstall File.expand_path(f.path)
      end
    end
  end
end
