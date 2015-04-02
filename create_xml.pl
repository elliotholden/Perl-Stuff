#!/usr/bin/perl

use strict;
use warnings;

my $infile = $ARGV[0];			#--> get file passed in as argument on the command line
my $outfile = $infile; 
$outfile =~ s/\..*/\.xml/;		#--> replace file extension with ".xml"

open (INFILE, "<", "$infile") or die "$!: Could not open file $infile\n";
my @lines = <INFILE>;			#--> read each line into an arrray
close(INFILE);

my %unique_categories;

foreach my $line(@lines) {		#--> iterate through the array
   if ($line !~ /^\s*$/) {		#--> process a line only if it's NOT a blank line
      chomp($line);			#--> get rid of the newline character "\n" on each line

      $line =~ s/>/&gt;/g;
      $line =~ s/</&lt;/g;
      $line =~ s/"//g;
      $line =~ s/&/&amp;/g;
      $line =~ s/'/&apos;/g;

      my @fields = split (/\t/, $line);	#--> split each line into an array
      foreach (@fields) {		#--> remove begining and trailing white space from each field
         $_ =~ s/^\s+//; 
         $_ =~ s/\s+$//; 
      }

      #*** create anonymoys array and assign it to the unique_categories hash if it doesn't already exists
      $unique_categories{$fields[4]} = [] unless exists $unique_categories{$fields[4]};

      push @{$unique_categories{$fields[4]}}, { #array value 4 is the "subclass" from the spreadsheet  
               sku => $fields[0], omsid => $fields[1], dept => $fields[2], class => $fields[3], subclass => $fields[4], 
               vendor => $fields[5], mcsonf => $fields[6], eco => $fields[7], category => $fields[8], desc => $fields[9],
	       extraurl => $fields[10], extracta => $fields[11] 
             };
   }
}

open (OUTFILE, ">", "$outfile") or die "$!: Could not create file $outfile"; 
print OUTFILE "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n";
print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>" . "\n";
print OUTFILE "<products>\n";
print "<products>\n";

foreach my $category (sort(keys(%unique_categories))) {
   print OUTFILE "\t<category header=\"$category\">" . "\n";
   print "\t<category header=\"$category\">" . "\n";
   foreach my $row ( @{$unique_categories{$category}} ) {
      print OUTFILE "\t\t<productrow sku=\"$row->{sku}\" vendor=\"$row->{vendor}\" description=\"$row->{desc}\" " . 
	    "omsid=\"$row->{omsid}\" extracta=\"$row->{extracta}\" extraurl=\"$row->{extraurl}\" tag=\"\" />" . "\n";
      print "\t\t<productrow sku=\"$row->{sku}\" vendor=\"$row->{vendor}\" description=\"$row->{desc}\" " . 
	    "omsid=\"$row->{omsid}\" extracta=\"$row->{extracta}\" extraurl=\"$row->{extraurl}\" tag=\"\" />" . "\n";
   }
   print OUTFILE "\t</category>" . "\n";
   print "\t</category>" . "\n";
}

print OUTFILE "</products>";
print "</products>\n";

close(OUTFILE);

#system("unix2dos $outfile"); #convert output file to DOS format and input file back to DOS format
exit;
