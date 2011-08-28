require 'formula'

def mysql_installed?
  `which mysql_config`.length > 0
end

class Lighttpd < Formula
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.28.tar.bz2'
  md5 '586eb535d31ac299652495b058dd87c4'
  homepage 'http://www.lighttpd.net/'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  if ARGV.include? '--with-mysql'
    depends_on 'mysql' => :recommended unless mysql_installed?
  end

  def options
   [
     ['--with-mysql', 'Include MySQL support (for mod_mysql_vhost)'],
   ]
  end

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-openssl", 
      "--with-ldap"
    ]

    if ARGV.include? '--with-mysql'
      mysql_formula = Formula.factory('mysql')
      if mysql_formula.installed?
        mysql_config = mysql_formula.prefix+"/bin/mysql_config"
      elsif mysql_installed?
        mysql_config = `which mysql_config`
      end
      args.push "--with-mysql="+mysql_config
    end

    system "./configure", *args
    system "make install"
  end
end
