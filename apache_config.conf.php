<VirtualHost *:443>
	ServerAdmin webmaster@localhost
	DocumentRoot <?=getcwd()?>/public_html
	
	# Map /sql to single PHP script
	<Location "/sql">
		RewriteEngine On
		RewriteBase /
		RewriteRule ^sql\.php$ – [L] 
		RewriteCond %{REQUEST_FILENAME} !-f 
		RewriteCond %{REQUEST_FILENAME} !-d 
		RewriteRule . sql.php [L] 
	</Location>

	# Map file requests to proper folder
	Alias "/FileAccess" "/ExtraSpace/Dropbox/IntranetV2_Files"
	<Directory "/ExtraSpace/Dropbox/IntranetV2_Files">
		Require all granted
	</Directory>

	# Enable BASH scripts
	<Directory "<?=getcwd()?>">
    		Options +ExecCGI
		AddHandler cgi-script .py
		AddHandler cgi-script .sh
	</Directory>

	<Location "/rest">
		RewriteEngine On
		RewriteBase /rest
		RewriteRule ^anyRestCommand\.php$ – [L] 
		RewriteCond %{REQUEST_FILENAME} !-f 
		RewriteCond %{REQUEST_FILENAME} !-d 
		RewriteRule . anyRestCommand.php [L] 
	</Location>

	## Force CSS files to be parse with a PHP engine
	<FilesMatch "\.css$">
	  SetHandler application/x-httpd-php
	</FilesMatch>

	## Server Name
	ServerName <?=basename(getcwd())=="master"?"v2":basename(getcwd())?>.intranetafm.com
	

	## SSL keys
	SSLCertificateFile /home/ubuntu/Dropbox/ApacheSSL/issued/STAR_intranetafm_com.crt
	SSLCertificateKeyFile /home/ubuntu/Dropbox/ApacheSSL/server.key
	
	## Custom Logs
	ErrorLog <?=getcwd()?>/log/apache2_error.log
	CustomLog <?=getcwd()?>/log/apache2_access.log combined
</VirtualHost>
