<?php

require_once __DIR__."/../../../db_support_functions.php";

/* MODES */
define("TEST_SUCCEED", 1);
define("TEST_ERROR_WITH_MESSAGE", 2);
define("TEST_ERROR_WITH_CODE", 3);

/* MariaDB / PDO error-info array indexes */
define("ERROR_CODE_IDX", 0);
define("SQLSTATE_IDX",   1);
define("ERROR_MSG_IDX",  2);

class UnitTest {

	private $description = "";
	private $testFn;
	private $testQuery = "";

	private $expectedResultType;
	private $expectedResultMsg = "";
	private $expectedResultCode = "";


	public function describe(string $d)         { $this->description = $d; return $this; }
	public function expect(callable $c)         { $this->testFn = $c; return $this; }
	public function expectQuery(string $q)      { $this->testQuery = $q; return $this; }

	public function toSucceed()	            { $this->expectedResultType = 1; return $this; }
	public function toErrWithMessage(string $m) { $this->expectedResultType = 2; $this->expectedResultMsg = $m; return $this; }
	public function toErrWithCode(string $c)    { $this->expectedResultType = 3; $this->expectedResultCode = $c; return $this; }

	public function go() 			    {
		if (!empty($this->testQuery)) {
			$errorInfo = 0;
			/* 1st case: expected success but query failed */
			if ($this->expectedResultType == TEST_SUCCEED && sql($this->testQuery,$errorInfo) === false) {
				echo "[".red_color("FAILED")." ] {$this->description}  \n";
				echo "          Expected ".green_color("success")."!\n";
				echo "          ".red_color("Failed")." with (code) message ({$errorInfo[ERROR_CODE_IDX]}) {$errorInfo[ERROR_MSG_IDX]}\n";
			/* 2nd case: expected fail but either suceeded or message is wrong */
			} elseif($this->expectedResultType == TEST_ERROR_WITH_MESSAGE && (sql($this->testQuery, $errorInfo) || $errorInfo[ERROR_MSG_IDX] != $this->expectedResultMsg)) {
				echo "[".red_color("FAILED")." ] {$this->description} \n";
				echo "          Expected ".red_color("failure")." with message {$this->expectedResultMsg}.\n";
				if ($errorInfo[2] != $this->expectedResultMsg)
				echo "          Got message $errorInfo[ERROR_MSG_IDX]\n";
				else
				echo "          But ".green_color("suceeded")."!\n";
			/* 3rd case: expected fail but either suceeded or code is wrong */
			} elseif($this->expectedResultType == TEST_ERROR_WITH_CODE && (sql($this->testQuery, $errorInfo) || $errorInfo[ERROR_CODE_IDX] != $this->expectedResultCode)) {
				echo "[".red_color("FAILED")." ] {$this->description} \n";
				echo "          Expected ".red_color("failure")." with code {$this->expectedResultCode}.\n";
				if ($errorInfo[ERROR_CODE_IDX] != $this->expectedResultCode)
				echo "          Got code ".$errorInfo[ERROR_CODE_IDX]."\n";
				else
				echo "          But ".green_color("suceeded")."!\n";
			} else {
				echo "[".green_color("SUCCESS")."] {$this->description}\n" ;
			}
	
			
		} else {
			$result = call_user_func($this->testFn);
		}

		
		
	}
}

class TestSuite {

	private $description;
	private $tests = [];

	public function __construct(string $d) { 
		sql("SET autocommit=0;");
		$this->description = $d; 
	}
	public function addTest(UnitTest $t) { $this->tests[] = $t; return $this; }
	public function go() {	
		sql("START TRANSACTION;");
		echo "TEST GROUP : ".$this->description."\n";
		foreach($this->tests as $k => $t)
			$t->go();
		sql("ROLLBACK;");

	}	
}

function red_color(string $s) { 
	if (getenv("HTML_MODE"))
		return "<span style=\"color: red;\">$s</span>";
	else
		return "\033[0;31m$s\033[0m"; 
}
function green_color(string $s) { 
	if (getenv("HTML_MODE"))
		return "<span style=\"color: green;\">$s</span>";
	else
		return "\033[0;32m$s\033[0m"; 
}
