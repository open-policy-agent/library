# These tests are commented out as they require kubectl proxy auth
# and the gate currently can not test against it.
# They are useful still for folks that want to manually test.

package kubernetes.lib_test

#import data.kubernetes.lib
#
#test_sar_unknown {
#	allowed := lib.sar_allowed({"namespace": "default", "verb": "*", "resource": "*"}, "root", ["foo", "bar"])
#	allowed == false
#}
#
#test_sar_ok {
#	allowed := lib.sar_allowed({"namespace": "default", "verb": "*", "resource": "*"}, "minikube-user", ["system:masters"])
#	allowed == true
#}
