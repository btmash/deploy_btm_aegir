from fabric.api import *
import time

def generate_drupal_platform(build, platform):
	print "===> Generating new platform ..."
	run("git clone --depth 1 -q git@repo.com/path/to/repo.git /path/to/platforms/%s" % (build))
	run("ln -s /path/to/sftp/docs /path/to/platforms/%s/docs" % (build))

def provision_drupal_platform(build, platform):
	print "===> Provisioning new platform ..."
	run("drush --root='/path/to/platforms/%s' --context_type='platform' provision-save '@platform_%s'" % (build, build))
	time.sleep(5)
	run("drush @hostmaster hosting-import '@platform_%s'" % (build))
	time.sleep(5)
	run("drush @hostmaster hosting-dispatch")

def migrate_drupal_platform(build, platform):
	print "===> Migrating platform websites ..."
	run("rm -f /path/to/platforms/scripts/migrate_sites.sh")
	put("/local/path/to/scripts/migrate_sites.sh", "/path/to/platforms/scripts/migrate_sites.sh")
	run("bash /path/to/platforms/scripts/migrate_sites.sh '%s' '@platform_%s'" % (platform, build))
	run("rm -f /path/to/platforms/scripts/migrate_sites.sh")
	time.sleep(30)
	run("chmod o+r /path/to/platforms/%s/sites" % (build))
	run("chmod o+r /path/to/platforms/%s/sites/all" % (build))

def cache_drupal_platform_sites(build, platform):
	print "===> Migrating platform websites ..."
	run("rm -f ~/static/cache_sites.sh")
	put("/var/lib/jenkins/scripts/cache_sites.sh", "~/static/cache_sites.sh")
	run("bash ~/static/cache_sites.sh '%s' '@platform_%s'" % (platform, build))
	run("rm -f ~/static/cache_sites.sh")

def replace_robots_txt(build, platform):
	print "===> REPLACE robots.txt with ignore version"
	run("rm -rf /path/to/platforms/%s/robots.txt" % (build))
	put('/local/path/to/scripts/robots.disallow.txt', "/path/to/platforms/%s/robots.txt" % (build))

