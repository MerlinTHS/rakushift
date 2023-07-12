unit module time;

class Time {
	has Int $.hours = 0;
	has Int $.minutes = 0;
	has Int $.seconds is rw = 0;
}

sub parse-time(Str $formatted) returns Time {
	fail "Cannot parse time [$formatted]" unless 
		$formatted ~~ / $<hours>=(\d\d) \: $<minutes>=(\d\d) \:? $<seconds>=(\d\d)? /;

	my $time = Time.new(
			hours => $<hours>.Int,
			minutes => $<minutes>.Int,
		);

	$time.seconds = $<seconds>.Int if $<seconds>.defined;
	$time
}