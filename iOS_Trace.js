
// 检查任意指针是否是有效的Objective-C对象
// 参考https://codeshare.frida.re/@mrmacete/objc-method-observer/


// 导入必要的模块和函数
// const { spawnSync } = require('child_process');
// const fs = require('fs');


var NSData = ObjC.classes.NSData;
var NSString = ObjC.classes.NSString;

function unicode2str(str) {
    var ret = "";
    var ustr = "";

    for (var i = 0; i < str.length; i++) {
        var code = str.charCodeAt(i);
        var code16 = code.toString(16);
        if (code < 0xf) {
            ustr = "\\u" + "000" + code16;
        } else if (code < 0xff) {
            ustr = "\\u" + "00" + code16;
        } else if (code < 0xfff) {
            ustr = "\\u" + "0" + code16;
        } else {
            ustr = "\\u" + code16;
        }
        ret += ustr;
    }
    return ret;
}

/* JavaScript String -> NSString */
function str(s) {
    return Memory.allocUtf8String(s);
}

function nsstr(str) {
    return ObjC.classes.NSString.stringWithUTF8String_(Memory.allocUtf8String(str));
}

/* NSString -> NSData */
function nsstr2nsdata(nsstr) {
    return nsstr.dataUsingEncoding_(4);
}

/* NSData -> NSString */
function nsdata2nsstr(nsdata) {
    return ObjC.classes.NSString.alloc().initWithData_encoding_(nsdata, 4);
}

/* Print Native Callstack */
function callstack() {
    console.log(Thread.backtrace(this.context, Backtracer.ACCURATE).map(DebugSymbol.fromAddress).join("\n") + "\n");
}

function callstack_() {
    console.log(ObjC.classes.NSThread.callStackSymbols().toString());
}


// color着色
var Color = {
    RESET: "\x1b[39;49;00m", Black: "0;01", Blue: "4;01", Cyan: "6;01", Gray: "7;01", Green: "2;01", Purple: "5;01", Red: "1;01", Yellow: "3;01",
    Light: {
        Black: "0;11", Blue: "4;11", Cyan: "6;11", Gray: "7;01", Green: "2;11", Purple: "5;11", Red: "1;11", Yellow: "3;11"
    }
};

var LOG = function (input, kwargs) {
    kwargs = kwargs || {};
    var logLevel = kwargs['l'] || 'log', colorPrefix = '\x1b[3', colorSuffix = 'm';
    if (typeof input === 'object')
        input = JSON.stringify(input, null, kwargs['i'] ? 2 : null);
    if (kwargs['c'])
        input = colorPrefix + kwargs['c'] + colorSuffix + input + Color.RESET;
    console[logLevel](input);
};


/* Get all modules */
function getmodule() {
    var modules = Process.enumerateModulesSync();
    return modules.map(function (item) {
        return item['path'];
    });
}

/* Get all class in module */
function getmoduleclass(module) {
    if (module == null) {
        module = Process.enumerateModulesSync()[0]['path'];
    }
    var pcount = Memory.alloc(4);
    Memory.writeU32(pcount, 0);
    var objc_copyClassNamesForImage = new NativeFunction(Module.findExportByName(null, "objc_copyClassNamesForImage"), "pointer", ["pointer", "pointer"]);
    var classptrarr = objc_copyClassNamesForImage(Memory.allocUtf8String(module), pcount);
    var count = Memory.readU32(pcount);
    var result = Array();
    for (var i = 0; i < count; i++) {
        var classptr = Memory.readPointer(classptrarr.add(Process.pointerSize * i));
        result.push(Memory.readUtf8String(classptr));
    }
    return result;
}

function getclassmodule(classname) {
    var objc_getClass = new NativeFunction(Module.findExportByName(null, "objc_getClass"), "pointer", ["pointer"]);
    var class_getImageName = new NativeFunction(Module.findExportByName(null, "class_getImageName"), "pointer",
        ["pointer"]);
    var class_ = objc_getClass(Memory.allocUtf8String(classname));
    return Memory.readUtf8String(class_getImageName(class_));
}

function getsymbolmodule(symbolname) {
    var dladdr = new NativeFunction(Module.findExportByName(null, "dladdr"), "int", ["pointer", "pointer"]);
    var info = Memory.alloc(Process.pointerSize * 4);
    dladdr(Module.findExportByName(null, symbolname), info);
    return {
        "fname": Memory.readUtf8String(Memory.readPointer(info)),
        "fbase": Memory.readPointer(info.add(Process.pointerSize)),
        "sname": Memory.readUtf8String(Memory.readPointer(info.add(Process.pointerSize * 2))),
        "saddr": Memory.readPointer(info.add(Process.pointerSize * 3)),
    }
}

function getaddressmodule(address) {
    var dladdr = new NativeFunction(Module.findExportByName(null, "dladdr"), "int", ["pointer", "pointer"]);
    var info = Memory.alloc(Process.pointerSize * 4);
    dladdr(ptr(address), info);
    return {
        "fname": Memory.readUtf8String(Memory.readPointer(info)),
        "fbase": Memory.readPointer(info.add(Process.pointerSize)),
        "sname": Memory.readUtf8String(Memory.readPointer(info.add(Process.pointerSize * 2))),
        "saddr": Memory.readPointer(info.add(Process.pointerSize * 3)),
    }
}

/* Get Objective-C Method of class */
function getclassmethod(classname) {
    var objc_getClass = new NativeFunction(Module.findExportByName(null, "objc_getClass"), "pointer", ["pointer"]);
    var objc_getMetaClass = new NativeFunction(Module.findExportByName(null, "objc_getMetaClass"), "pointer", ["pointer"]);
    var class_ = objc_getClass(Memory.allocUtf8String(classname));
    var metaclass_ = objc_getMetaClass(Memory.allocUtf8String(classname));
    var pcount = Memory.alloc(4);
    Memory.writeU32(pcount, 0);
    var class_copyMethodList = new NativeFunction(Module.findExportByName(null, "class_copyMethodList"), "pointer", ["pointer", "pointer"]);
    var method_getName = new NativeFunction(Module.findExportByName(null, "method_getName"), "pointer", ["pointer"]);
    var method_getImplementation = new NativeFunction(Module.findExportByName(null, "method_getImplementation"), "pointer", ["pointer"]);
    var methodptrarr = class_copyMethodList(class_, pcount);
    var count = Memory.readU32(pcount);
    var result = new Array();
    for (var i = 0; i < count; i++) {
        var method = Memory.readPointer(methodptrarr.add(Process.pointerSize * i));
        var name = Memory.readUtf8String(method_getName(method));
        var imp = method_getImplementation(method);
        result.push({ "name": "- " + name, "imp": imp });
        //console.log("-[" + classname + " " + name + "] -> " + imp);
    }
    Memory.writeU32(pcount, 0);
    methodptrarr = class_copyMethodList(metaclass_, pcount);
    count = Memory.readU32(pcount);
    for (var i = 0; i < count; i++) {
        var method = Memory.readPointer(methodptrarr.add(Process.pointerSize * i));
        var name = Memory.readUtf8String(method_getName(method));
        var imp = method_getImplementation(method);
        result.push({ "name": "+ " + name, "imp": imp });
        //console.log("+[" + classname + " " + name + "] -> " + imp);
    }
    return result;
}

// 强制过证书校验
function forcetrustcert() {
    Interceptor.replace(Module.findExportByName(null, 'SecTrustEvaluate'),
        new NativeCallback(function (trust, result) {
            Memory.writePointer(result, ptr('0x1'));
            console.log('pass SecTrustEvaluate');
            return 0;
        }, 'int', ['pointer', 'pointer'])
    );
    /* 获取app路径下的可执行模块 hook存在以下方法的类
        - evaluateServerTrust:forDomain:
        - allowInvalidCertificates
        - shouldContinueWithInvalidCertificate
    */
    var apppath = Process.enumerateModulesSync()[0]['path'];
    apppath = apppath.slice(0, apppath.lastIndexOf('/'));
    getmodule().forEach(function (module, i) {
        if (module.indexOf(apppath) != 0) return;
        getmoduleclass(module).forEach(function (classname, j) {
            getclassmethod(classname).forEach(function (methodinfo, k) {
                var name = methodinfo['name'];
                if (name == '- evaluateServerTrust:forDomain:' ||
                    name == '- allowInvalidCertificates' ||
                    name == '- shouldContinueWithInvalidCertificate') {
                    console.log("forcetrustcert " + classname + " " + name);
                    Interceptor.attach(methodinfo['imp'], {
                        onEnter: function (args) {
                            console.log("forcetrustcert " + classname + " " + name);
                        },
                        onLeave: function (retval) {
                            retval.replace(ptr('0x1'));
                        }
                    });
                }
            });
        });
    });
}

// 随机字符串
function randomString(len) {
    len = len || 32;
    var $chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
    var maxPos = $chars.length;
    var pwd = '';
    for (i = 0; i < len; i++) {
        pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
    }
    return pwd;
}

// 生成二进制NSData
function rawnsdata() {
    var buf = Memory.alloc(256);
    for (var i = 0; i < 256; i++) {
        Memory.writeU8(buf.add(i), i);
    }
    return ObjC.classes.NSData.dataWithBytes_length_(buf, 256);
}

function dump_alertview() {
    ObjC.chooseSync(ObjC.classes.UIAlertController).forEach(
        function (alertcontroller) {
            var actions = alertcontroller.actions();
            for (var i = 0; i < actions.count(); i++) {
                var action = actions.objectAtIndex_(i);
                var handler = action.handler();
                if (handler != null) handler = handler.handle;
                console.log(action.title(), handler);
            }
        }
    );
}

function get_object_method_address(object, action) {
    var class_getMethodImplementation = new NativeFunction(Module.findExportByName(null, "class_getMethodImplementation"), "pointer", ["pointer", "pointer"]);
    var imp = class_getMethodImplementation(object.class(), ObjC.selector(action));
    var mod = Process.getModuleByAddress(imp);
    return mod['name'] + '!' + imp.sub(mod['base'])
}

function get_function_address(address) {
    address = ptr(address);
    var symbol = getaddressmodule(address);
    var sympath = symbol['fname'];
    var symname = sympath.split('/')[sympath.split('/').length - 1];
    return symname + '!' + address.sub(symbol['fbase']);
}

// 遍历界面元素
function tranverse_view() {
    var appCls = ObjC.classes["NSApplication"] || ObjC.classes["UIApplication"];
    var mainwin = appCls.sharedApplication().keyWindow();
    var arr = Array();
    function find_subviews_internal(view, depth) {
        if (view == null) {
            return;
        }
        var space = '';
        for (var i = 0; i < depth; i++) {
            space += '-';
        }
        var text = '';
        var ctrlname = view.class().toString();
        if (view.respondsToSelector_(ObjC.selector('text'))) {
            text = view.text() == null ? "" : view.text().toString();
        }
        var responder = '';
        var iter = true;
        if (view.respondsToSelector_(ObjC.selector('allTargets'))) {
            var targets = view.allTargets().allObjects();
            if (targets != null) {
                var targetcount = targets.count();
                var events = view.allControlEvents();
                for (var i = 0; i < targetcount; i++) {
                    var target = targets.objectAtIndex_(i);
                    var actions = view.actionsForTarget_forControlEvent_(target, events);
                    if (actions != null) {
                        var actioncount = actions.count();
                        for (var j = 0; j < actioncount; j++) {
                            var clsname = target.class().toString();
                            var action = actions.objectAtIndex_(j).toString();
                            var addr = get_object_method_address(target, action)
                            responder += '[' + clsname + ' ' + action + ']=' + addr + ',';
                        }
                    }
                }
            }
        }
        var msg = space + ctrlname + " " + view.handle;
        if (text.length > 0) {
            msg += "  => " + unicode2str(text);
        }
        if (responder != '') {
            msg += "  selectors= " + responder;
        }
        console.log((msg));
        if (view.respondsToSelector_(ObjC.selector('actions'))) {
            // UIAlertView
            iter = false;
            var actions = view.actions();
            var actioncount = actions.count();
            for (var j = 0; j < actioncount; j++) {
                var action = actions.objectAtIndex_(j);
                var title = action.title().UTF8String();
                if (action.handler() == null) {
                    console.log((space + '  action= ' + unicode2str(title)));
                } else {
                    var block = action.handler().handle;
                    var funcaddr = Memory.readPointer(block.add(Process.pointerSize * 2));
                    var types = action.handler().types;
                    var addr = get_function_address(funcaddr);
                    console.log((space + '  action= ' + unicode2str(title) + ' ' + types + ' ' + addr));
                }
            }
        }
        if (view.respondsToSelector_(ObjC.selector('gestureRecognizers'))) {
            var gestures = view.gestureRecognizers();
            if (gestures != null) {
                var gesturecount = gestures.count();
                for (var k = 0; k < gesturecount; k++) {
                    var gesture = gestures.objectAtIndex_(k);
                    var targets = ObjC.Object(gesture.handle.add(16).readPointer());
                    if (targets.handle.isNull()) {
                        continue;
                    }
                    var targetcount = targets.count();
                    for (var l = 0; l < targetcount; l++) {
                        var target = targets.objectAtIndex_(l);
                        var addr = get_function_address(target.action());
                        console.log(space + 'action', addr);
                    }
                }
            }

            /*for (var j = 0; j < gesturecount; j++) {
                var gesture = gestures.objectAtIndex_(j);

            }*/
        }
        var subviews = view.subviews();
        if (subviews != null && iter) {
            var subviewcount = subviews.count();
            for (var i = 0; i < subviewcount; i++) {
                var subview = subviews.objectAtIndex_(i);
                find_subviews_internal(subview, depth + 1);
            }
        }
    }

    find_subviews_internal(mainwin, 0);
}

function trace_view() {
    var UIApplication = ObjC.classes.UIApplication;
    Interceptor.attach(UIApplication["- sendAction:to:from:forEvent:"].implementation, {
        onEnter: function (args) {
            var action = Memory.readUtf8String(args[2]);
            var toobj = ObjC.Object(args[3]);
            var fromobj = ObjC.Object(args[4]);
            var event = ObjC.Object(args[5]);
            console.log('SendAction:' + action + ' to:' + toobj.toString() +
                ' from:' + fromobj.toString() + ' forEvent:' + event.toString() + ']');
        }
    });
}


/* c function wrapper */
function getExportFunction(type, name, ret, args) {
    var nptr;
    nptr = Module.findExportByName(null, name);
    if (nptr === null) {
        console.log("cannot find " + name);
        return null;
    } else {
        if (type === "f") {
            var funclet = new NativeFunction(nptr, ret, args);
            if (typeof funclet === "undefined") {
                console.log("parse error " + name);
                return null;
            }
            return funclet;
        } else if (type === "d") {
            var datalet = Memory.readPointer(nptr);
            if (typeof datalet === "undefined") {
                console.log("parse error " + name);
                return null;
            }
            return datalet;
        }
    }
}

function modload(modpath) {
    var dlopen = getExportFunction("f", "dlopen", "pointer", ["pointer", "int"]);
    dlopen(str(modpath), 1);
}

function getscreensize() {
    var UIScreen = ObjC.classes.UIScreen;
    return UIScreen.mainScreen().bounds()[1];
}

function click(x, y) {
    // https://github.com/zjjno/PTFakeTouchDemo.git 编译为dylib
    modload("/Library/MobileSubstrate/DynamicLibraries/PTFakeTouch.dylib")
    var touchxy = getExportFunction("f", "touchxy", "void", ["int", "int"]);
    touchxy(x, y);
}

function _utf8_encode(string) {
    string = string.replace(/\r\n/g, "\n");
    var utftext = "";
    for (var n = 0; n < string.length; n++) {
        var c = string.charCodeAt(n);
        if (c < 128) {
            utftext += String.fromCharCode(c);
        } else if ((c > 127) && (c < 2048)) {
            utftext += String.fromCharCode((c >> 6) | 192);
            utftext += String.fromCharCode((c & 63) | 128);
        } else {
            utftext += String.fromCharCode((c >> 12) | 224);
            utftext += String.fromCharCode(((c >> 6) & 63) | 128);
            utftext += String.fromCharCode((c & 63) | 128);
        }
    }
    return utftext;
}

// 获取keychain数据
function getkeychain() {
    var NSMutableDictionary = ObjC.classes.NSMutableDictionary;
    var kCFBooleanTrue = ObjC.Object(getExportFunction("d", "kCFBooleanTrue"));
    var kSecReturnAttributes = ObjC.Object(getExportFunction("d", "kSecReturnAttributes"));
    var kSecMatchLimitAll = ObjC.Object(getExportFunction("d", "kSecMatchLimitAll"));
    var kSecMatchLimit = ObjC.Object(getExportFunction("d", "kSecMatchLimit"));
    var kSecClassGenericPassword = ObjC.Object(getExportFunction("d", "kSecClassGenericPassword"));
    var kSecClassInternetPassword = ObjC.Object(getExportFunction("d", "kSecClassInternetPassword"));
    var kSecClassCertificate = ObjC.Object(getExportFunction("d", "kSecClassCertificate"));
    var kSecClassKey = ObjC.Object(getExportFunction("d", "kSecClassKey"));
    var kSecClassIdentity = ObjC.Object(getExportFunction("d", "kSecClassIdentity"));
    var kSecClass = ObjC.Object(getExportFunction("d", "kSecClass"));

    var query = NSMutableDictionary.alloc().init();
    var SecItemCopyMatching = getExportFunction("f", "SecItemCopyMatching", "int", ["pointer", "pointer"]);
    [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey,
        kSecClassIdentity].forEach(function (secItemClass) {
            query.setObject_forKey_(kCFBooleanTrue, kSecReturnAttributes);
            query.setObject_forKey_(kSecMatchLimitAll, kSecMatchLimit);
            query.setObject_forKey_(secItemClass, kSecClass);
            var result = Memory.alloc(8);
            Memory.writePointer(result, ptr("0"));
            SecItemCopyMatching(query.handle, result);
            var pt = Memory.readPointer(result);
            if (!pt.isNull()) {
                console.log(ObjC.Object(pt).toString());
            }
        }
        )
}

/* Base64 Encode */
function base64(input) {
    var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    var output = "";
    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
    var i = 0;
    input = _utf8_encode(input);
    while (i < input.length) {
        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);
        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;
        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }
        output = output + _keyStr.charAt(enc1) + _keyStr.charAt(enc2) + _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
    }
    return output;
}

function CheckObjc(p) {
    var klass = getObjCClassPtr(p);
    return !klass.isNull();
}

function getObjCClassPtr(p) {
    /*
     * Loosely based on:
     * https://blog.timac.org/2016/1124-testing-if-an-arbitrary-pointer-is-a-valid-objective-c-object/
     */
    var ISA_MASK = ptr('0x0000000ffffffff8');
    var ISA_MAGIC_MASK = ptr('0x000003f000000001');
    var ISA_MAGIC_VALUE = ptr('0x000001a000000001');

    if (!isReadable(p))
        return NULL;
    var isa = p.readPointer();
    var classP = isa;
    if (classP.and(ISA_MAGIC_MASK).equals(ISA_MAGIC_VALUE))
        classP = isa.and(ISA_MASK);
    if (isReadable(classP))
        return classP;
    return NULL;
}

function isReadable(p) {
    try {
        p.readU8();
        return true;
    } catch (e) {
        return false;
    }
}

 

// https://codeshare.frida.re/@lichao890427/ios-utils/
// var NSData = ObjC.classes.NSData;
// var NSString = ObjC.classes.NSString;

// /* NSData -> NSString */
// function NSData2NSString(NSData) {
//     return ObjC.classes.NSString.alloc().initWithData_encoding_(NSData, 4);
// }


// generic trace
function trace(pattern) {
    var type = (pattern.indexOf(" ") !== -1) ? "objc" : "module";
    var res = new ApiResolver(type);
    var matches = res.enumerateMatchesSync(pattern);
    var targets = uniqBy(matches, JSON.stringify);

    targets.forEach(function (target) {
        if (type === "objc") {
            var filter = [  // 自定义过滤条件，方法名称中不含以下关键词
                "SDK",
                "Monitor",
                "_"
            ];
            for (var i = 0, Traceflag = 0; i < filter.length; i++) {
                if (target.name.indexOf(filter[i]) != -1) {
                    Traceflag = 1;
                }
            }
            if (Traceflag === 0) {
                LOG("Tracing - Name: " + target.name + " address: " + target.address, { c: Color.Gray });
                // console.log("Tracing " + target.name +" "+ target.address);
                traceObjC(target.address, target.name);
            }
        }
        else if (type === "module") {
            traceModule(target.address, target.name);
        }
    });
}

// remove duplicates from array
function uniqBy(array, key) {
    var seen = {};
    return array.filter(function (item) {
        var k = key(item);
        return seen.hasOwnProperty(k) ? false : (seen[k] = true);
    });
}

// trace ObjC methods
function traceObjC(impl, name) {
    Interceptor.attach(impl, {
        onEnter: function (args) {
            // debug only the intended calls
            console.log("Tracing " + name);
            console.log("[+] ---------------------------------------------------------------");
            LOG("*** entering " + name, { c: Color.Green });
            // console.log("*** entered " + name);

            // print full backtrace
            // console.log('\tACCURATE Backtrace:\n\t' + Thread.backtrace(this.context,Backtracer.ACCURATE).map(DebugSymbol.fromAddress).join('\n\t'));
            // console.log('\tFUZZY Backtrace:\n\t' + Thread.backtrace(this.context,Backtracer.FUZZY).map(DebugSymbol.fromAddress).join('\n\t'));


            // print caller
            console.log("[+] Caller: " + DebugSymbol.fromAddress(this.returnAddress));

            // print args
            if (name.indexOf(":") !== -1) {  // 有参数的逻辑处理
                var param = name.split(":");
                param[0] = param[0].split(" ")[1];
                for (var i = 0; i < param.length - 1; i++) {
                    // console.log("[+] args"+"["+ (i+2) +"] objc: " + CheckObjc(args[i + 2]));
                    if (CheckObjc(args[i + 2])) {
                        printArg("arg" + (i + 2) + " " + param[i] + ": ", args[i + 2]);
                    }
                }



                // 防止遗漏Receiver对象
                if (CheckObjc(args[0])) {
                    // 无参数的Objective-C方法，打印args[0]
                    var param1 = new ObjC.Object(args[0]);
                    LOG("[+++++] 类 args[0]: " + param1, { c: Color.Gray });
                    // console.log("[+] args[0]: " + param1);
                    console.log("[++++] type: " + param1.$className);
                    // if(param1.$className == "RCTScrollView"){
                    //     console.log(param1.$className+"  setContentOffset_animated");
                    //     //args[0]: <RCTScrollView: 0x106045a00; reactTag: 725; frame = (0 0; 347 173.5); clipsToBounds = YES; layer = <CALayer: 0x28103bee0>>

                    //     // var offset = param1.contentOffset();
                    //     // //param1.setContentOffset_animated_({x: offset.x, y: offset.y - 1000}, 0.5);

                    //     // var bottomOffset = {x: 0, y: contentSize.height - param1.bounds().size.height};
                    //     // if (bottomOffset.y < 0) {
                    //     //     bottomOffset.y = 0;
                    //     // }
                    //     // param1.setContentOffset_animated_(bottomOffset, true);

                    // }
                }

            } else {  // 无参数的逻辑处理,如-[NSString md5]
                if (CheckObjc(args[0])) {
                    // 无参数的Objective-C方法，打印args[0]
                    var param1 = new ObjC.Object(args[0]);
                    LOG("[+] 类 args[0]: " + param1, { c: Color.Gray });
                    // console.log("[+] args[0]: " + param1);
                    console.log("[+] type: " + param1.$className);
                }
            }
        },

        onLeave: function (retval) {
            // console.log("[+] retval objc: " + CheckObjc(retval));
            if (CheckObjc(retval)) {
                printArg("retval: ", retval);

                // var objcParam = ObjC.Object(retval);
                // var objcType = objcParam.$className;

                // if(objcType == "__NSCFString"){
                //     //objcParam = "https://res.exexm.com/cw_145225549855002";
                //     //retval.replace("https://video.dcgvc.com/video/m3u8/2023/03/27/6df8ee4e/diba.ts");
                // }

            }

            LOG("*** exited " + name, { c: Color.Green });
            // console.log("*** exiting " + name);
            console.log("[-] ---------------------------------------------------------------\n");
        }
    });
}

// print helper
function printArg(desc, arg) {
    try {
        var objcParam = ObjC.Object(arg);
        var objcType = objcParam.$className;

        // [+] arg3: {length = 36, bytes = 0x37374131 30324232 2d323736 462d3435 ... 34333430 43313143 }
        // [+] type: NSConcreteMutableData
        // ==>
        // [+] arg3: 77A102B2-276F-4542-8F33-0DF84340C11C
        // [+] type: __NSCFString



        if (desc.indexOf("arg") != -1) {   // 区分参数与返回值着色


            if (objcType == "NSConcreteMutableData" || objcType == "OS_dispatch_data" || objcType == "_NSInlineData" || objcType == "NSConcreteData") {    // 将NSConcreteMutableData等类型转化为
                LOG("[+] 参数为NSData 不显示", { c: Color.Gray });
                // objcParam = objcParam.CKHexString();  
                        
                // 将数据转换为字符串
                // const jsonString = objcParam.toString();  
                // 非可见字符, 打印hex
                // console.log("DATA Base64数据: "+base64(jsonString));
                     
                
            } else {
                LOG("[+] " + desc + objcParam, { c: Color.Gray });
            }



        } else {
            //LOG("[+] " + desc + objcParam, { c: Color.Cyan });

            if (objcType == "NSConcreteMutableData" || objcType == "OS_dispatch_data" || objcType == "_NSInlineData" || objcType == "NSConcreteData") {    // 将NSConcreteMutableData等类型转化为NSString打印
                console.log("[返回值]" + objcType + " NSData 类型数据，不显示");
                try {
                    // objcParam = NSData2NSString(objcParam);  // 非可见字符不会报异常

                    if (objcParam.length() == 16 ){
                        // 获取 NSData 对象中的字节数组
                        //var bytes = Memory.readByteArray(objcParam.bytes(), objcParam.length());
                        //LOG("返回值解密16位IV打印hex ====== " + objcParam);
                    }else{
                        var newobjcParam = objcParam.bytes().readUtf8String(objcParam.length());
                        
                        // let jsonResponse = JSON.parse(newobjcParam);                    
                        // console.log("NSData 返回值解密:" + jsonResponse);
                        //send(newobjcParam);
                          LOG("返回值解密长度:"+newobjcParam.length, { c: Color.Yellow });
                          if(newobjcParam.length>100){
                            send(newobjcParam);
                          }
                    }
                    

                } catch (e) {     
                    LOG("解析ERROR: " + e, { c: Color.Red });            
                    //加密随机IV
                    //if (objcParam.length() == 16 ){
                        // 转换为 Base64
                        // var encoder = new ObjC.Base64Encoder();
                        // encoder.write(bytes, bytes.length);
                        // var base64Str = encoder.finish();
                        //objcParam.bytes()
                        //  var array = Memory.fromHex(objcParam.CKHexString()).readByteArray(objcParam.length());


                        // 将 NSInlineData 对象转换为 JavaScript 中的 Uint8Array 类型
                      
                        //if(objcParam.$kind == "instance"){      
                            // 计算 inline data 的开始地址
                            //    var startAddr = ptr(objcParam.bytes().toString()).add(Process.pointerSize * 2); // 跳过 isa 和 flags 字段

                            
                       // }
                        

                        // console.log("=====Base64: " + base64encode(bin2string(array)));
                   // }
                    //打印hex:<9d452cf0 d6146289 8e82b85b dff7a311>
                    //const jsonString = objcParam.toString();  
                    
                    // objcParam = objcParam.CKHexString();  
                        
                    // // 将数据转换为字符串
                   
                     // 非可见字符, 打印hex
                    //  var array = new Uint8Array(Memory.readByteArray(objcParam.bytes(), Memory.readUInt(objcParam.length())));

                    //  LOG("[+]  打印hex Base64后: " + base64encode(bin2string(array)), { c: Color.Yellow });

                    // console.log("加密Base64数据: "+base64(jsonString));
                }
                
                // var objcParam22 = NSData2NSString(objcParam);  // 非可见字符不会报异常
                //console.log(">> 解密数据: >>> "+nsstr(objcParam));



                let jsonResponse;
                try {


                    // const jsonString = objcParam.toString();  
                    //jsonResponse = JSON.parse(jsonString);
                    //send("\t- Attributes : " + jsonString);
                    // send(jsonString);
                    // LOG(jsonString);
                    // 0x10212c800 

                    // console.log("getclassmodule : " + getclassmodule("RCTCustomScrollView"));
                    // 通过对象地址获取对象
                    // const address = 0x10212c800/* 对象地址 */;
                    // const obj = getaddressmodule(address);
                    // console.log("scrollView: "+obj.class);
                    //scrolltobottom();
                    // var scrollview = 0x116178c00;

                    // 获取 Objective-C 运行时模块
                    // const objc = ObjC;

                    // // 通过对象地址获取对象
                    // const address = 0x1050f2c00; /* RCTCustomScrollView: 0x1050f2c00; 对象地址 */;
                    // const object = new ObjC.Object(address);

                    // // 将对象转换为 Objective-C 视图对象
                    // const view = new objc.classes.UIView(object);
                    // console.log(view);

                } catch (e) {
                    console.error("Failed:", e);
                   // console.error(jsonString);
                    return;
                }
                /*// 解析 JSON 数据
                let jsonResponse;
                try {
                    jsonResponse = JSON.parse(jsonString);
                    //解析返回数据 //这里处理每个tab 类目的所有JSON信息
                    if (jsonResponse.code == 0 || jsonResponse.data != null){
                        const categoryName = jsonResponse.data.category_name;
                        const categoryId = jsonResponse.data.category_id;
                        const videos = jsonResponse.data.videos;
                        const next_start_offset =  jsonResponse.data.next_start_offset;
                        
                        console.log("categoryId : " + categoryId +  " categoryName: " + categoryName);
                        if(nsstr(categoryId).length()>10){
                             //说明就是按照类目拉取的数据
                             const fileName = '/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/dbjson/'+categoryId+'_'+next_start_offset+'.json';
                             console.log("Json写入文件"+fileName);
                             const outputStr = `${JSON.stringify(videos)}\n`;
                            // fs.writeFileSync(fileName, outputStr, { flag: 'a' });
                            // console.log("outputStr: "+outputStr);
                            const str = ObjC.classes.NSString.stringWithString_(outputStr);
                            // const nsdata = str.dataUsingEncoding_(4);
                            // nsdata.writeToFile_atomically_(fileName, true);
                            //send("message",categoryId,categoryName,next_start_offset,str);
                            //send(''+jsonString);
                            // send(objcParam);
                            // var obj = ObjC.Object(args[4]);
                            send("\t- Attributes : " + jsonString);
                            console.log("Json写入文件OK...");
                        }  
                    }
               
                } catch (e) {
                    console.error("Failed:", e);
                    return;
                }
                */

            } else {

                LOG("[返回值] " + objcType + " " + desc + " " + objcParam, { c: Color.Cyan });
            }
        }
        // console.log("[+] " + desc + objcParam);

        console.log("[+] type: " + objcType);
    } catch (err) {
        console.log("error: " + desc + arg);
    }
}

function base64Encode(data) {
    var encoder = new Base64Encoder();
    encoder.write(data.bytes(), data.length());
    return encoder.finish();
  }

function scrolltobottom() {
    // 查找 UIScrollView 实例
    // 导入 UIKit 库
    var UIKit = ObjC.classes.UIKit;
    // 导入 Foundation 库
    var Foundation = ObjC.classes.Foundation;

    var scrollView = ObjC.classes.UIScrollView.alloc().init();

    // 获取当前的 UIWindow
    var appCls = ObjC.classes["NSApplication"] || ObjC.classes["UIApplication"];
    var window = appCls.sharedApplication().keyWindow();
    // var controller = window.rootViewController;

    // while (controller.presentedViewController) {
    //     controller = controller.presentedViewController;
    //   }
    if (window != null) {
        // 定义悬浮按钮类
        class FloatingButton {
            constructor(imageName, onClick) {
                this.imageName = imageName;
                this.onClick = onClick;
                this.button = null;
            }

            // 创建并配置按钮
            createButton() {
                if (this.button == null) {
                    this.button = ObjC.class.UIButton.buttonWithType(ObjC.UIButtonTypeCustom);
                    //this.button.setImage(UIImage.imageNamed(this.imageName), UIControlStateNormal);
                    this.button.addTarget_action_forControlEvents_(this, ObjC.selector("handleClick:"), ObjC.UIControlEvents.TouchUpInside);
                }
                return this.button;
            }

            // 按钮点击事件处理函数
            handleClick(sender) {
                console.log("Floating button clicked!");
                this.onClick(sender);
            }
        }
        // 定义开始任务按钮类
        class StartTaskButton extends FloatingButton {
            constructor(onClick) {
                super("start_task_button.png", onClick);
                this.timer = null;
            }

            // 开始任务
            startTask() {
                this.stopTimer();
                this.timer = ObjC.class.NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_(1.0, this, ObjC.selector("findCurrentViewController"), null, true);
                console.log("Task started.");
            }

            // 停止定时器
            stopTimer() {
                if (this.timer != null) {
                    this.timer.invalidate();
                    this.timer = null;
                }
            }

            // 查找当前显示的视图控制器
            findCurrentViewController() {
                // var controller = UIApplication.sharedApplication().keyWindow.rootViewController;
                // while (controller.presentedViewController) {
                //     controller = controller.presentedViewController;
                // }
                // console.log("Current view controller:", controller.class().toString());
            }
        }


        // 定义暂停任务按钮类
        class PauseTaskButton extends FloatingButton {
            constructor(onClick) {
                super("pause_task_button.png", onClick);
            }

            // 停止任务
            stopTask() {
                console.log("Task stopped.");
            }
        }

        // 创建开始任务按钮和暂停任务按钮
        var startTaskButton = new StartTaskButton(function (sender) {
            startTaskButton.startTask();
        });
        var pauseTaskButton = new PauseTaskButton(function (sender) {
            startTaskButton.stopTimer();
            pauseTaskButton.stopTask();
        });

        // 添加开始任务按钮到窗口上
        // var button = ObjC.classes.UIButton.buttonWithType(ObjC.UIButtonTypeCustom);
        var defaultManager = ObjC.classes.NSFileManager.defaultManager();
        //this.button.setImage(UIImage.imageNamed(this.imageName), UIControlStateNormal);
        //button.addTarget_action_forControlEvents_(this, ObjC.selector("handleClick:"), ObjC.UIControlEvents.TouchUpInside);
        console.log("button: "+defaultManager);

        // var startButton = startTaskButton.createButton();
         //startButton.frame = CGRectMake(
            // UIScreen.mainScreen().bounds.size.width - 80,
            // (UIScreen.mainScreen().bounds.size.height / 2) - 40,
            // 60, 80);
        //console.log("button: "+button);
        //var window = UIApplication.sharedApplication().keyWindow;
        // window.addSubview(startButton);

        // // 添加暂停任务按钮到窗口上
        // var pauseButton = pauseTaskButton.createButton();
        // pauseButton.frame = CGRectMake(
        //     UIScreen.mainScreen().bounds.size.width - 80,
        //     (UIScreen.mainScreen().bounds.size.height / 2) + 20,
        //     60, 80);
        // window.addSubview(pauseButton);

    }
 
    /*
   // console.log("subviews(): "+window.subviews());

    if (scrollView != undefined ) {
        
        var contentSize = scrollView.contentSize();
        // ...

        // 自动滚动 UIScrollView 到底部
        var contentSize = scrollView.contentSize();
        if(contentSize.height > 0){
            console.log("contentSize"+contentSize);
            // 如果找到了 UIScrollView 控件，则向上快速滑动
            var offset = scrollView.contentOffset();
            scrollView.setContentOffset_animated_({x: offset.x, y: offset.y - 1000}, 0.5);
        }
        
    }
     */
}

// trace ObjC methods
function traceAESUtils(impl, name) {
    Interceptor.attach(impl, {
        onEnter: function (args) {
            // debug only the intended calls
            console.log("Tracing " + name);
            console.log("[+] ---------------------------------------------------------------");
            LOG("*** entering " + name, { c: Color.Green });
            // console.log("*** entered " + name);

            // print full backtrace
            // console.log('\tACCURATE Backtrace:\n\t' + Thread.backtrace(this.context,Backtracer.ACCURATE).map(DebugSymbol.fromAddress).join('\n\t'));
            // console.log('\tFUZZY Backtrace:\n\t' + Thread.backtrace(this.context,Backtracer.FUZZY).map(DebugSymbol.fromAddress).join('\n\t'));

            // print caller
            // console.log("[+] Caller: " + DebugSymbol.fromAddress(this.returnAddress));

            // print args
            if (name.indexOf(":") !== -1) {  // 有参数的逻辑处理
                var param = name.split(":");
                param[0] = param[0].split(" ")[1];
                for (var i = 0; i < param.length - 1; i++) {
                    // console.log("[+] args"+"["+ (i+2) +"] objc: " + CheckObjc(args[i + 2]));
                    if (CheckObjc(args[i + 2])) {
                        printArg("arg" + (i + 2) + " " + param[i] + ": ", args[i + 2]);
                    }
                }
                // 防止遗漏Receiver对象
                if (CheckObjc(args[0])) {
                    // 无参数的Objective-C方法，打印args[0]
                    var param1 = new ObjC.Object(args[0]);
                    LOG("[+] args[0]: " + param1, { c: Color.Gray });
                    // console.log("[+] args[0]: " + param1);
                    console.log("[+] type: " + param1.$className);
                }

            } else {  // 无参数的逻辑处理,如-[NSString md5]
                if (CheckObjc(args[0])) {
                    // 无参数的Objective-C方法，打印args[0]
                    var param1 = new ObjC.Object(args[0]);
                    LOG("[+] args[0]: " + param1, { c: Color.Gray });
                    // console.log("[+] args[0]: " + param1);
                    console.log("[+] type: " + param1.$className);
                }
            }
        },

        onLeave: function (retval) {
            // console.log("[+] retval objc: " + CheckObjc(retval));
            if (CheckObjc(retval)) {
                // printArg("retval: ", retval);
            }

            LOG("*** exiting " + name, { c: Color.Green });
            // console.log("*** exiting " + name);
            console.log("[-] ---------------------------------------------------------------\n");
        }
    });
}



// ----------------------usage examples---------------------------
if (ObjC.available) {

    // trace("*[* *md5*]"); //trace("*[* *MD5*]");
    // trace("*[* *Encode*]");
    // trace("*[* setObject:forKey:]");
    // trace("+[* *write*:]");
    // trace("*[MD5 *]");
    // trace("*[* *Sign*:*]");
    // trace("*[* *base64*:*]");
    // trace("*[* *Encrypt*:*]");


    // trace("-[NSMutableURLRequest setValue:forHTTPHeaderField:]");

    // trace("*[AESUtils *]");  //文件协议解密类

    // trace("*[ServerConnectUtils *]");

    // trace("*[AESUtils decryptFile*]");

    // trace("*[IJKFFMoviePlayerController setHudUrl*]"); //播放类，设置URL

    // trace("*ijkmp_get_msg*");

    // trace("*[M3U8Parser setM3u8NetAddress*]");
    // trace("*[M3U8Parser setKey*]");

    scrolltobottom();
    trace("*[M3U8Parser lastM3U8String]");

    // trace("*[RNAESUtils *]");
    // trace("*[M3U8DownloaderModel *]");  //离线下载
    trace("*[DADownloadUrlResolver *]");
    trace("-[RNServiceConnect rnSend*:*]");
    trace("*[InitServerConnect *]");
    // trace("*[IJKFFMoviePlayerController initWithContentURL*]");

    trace("*[ServerConnectUtils sendHttpPost*]");
    trace("*[ServerInfo getVideoAESKey]");
    trace("*[AESUtils encrypt*]");
    // trace("*[AESUtils decrypt*]");
    trace("*[AESUtils decrypt:key:]");
    trace("*[AESUtils decryptWithCBC:key:]");
    trace("*[* baseDecryptCbcWithIv*]");
    // trace("*[vGrowthConnectUtils *]");

    // trace("*[AESUtils GetRandomIvCode]");
    // trace("*[AESUtils decryptWithCBC:key:]");
    // trace("*[RCTCustomScrollView handleCustomPan*]");
    // trace("*[RCTCustomScrollView initWithFrame*]");
    // trace("*[RCTScrollView setShowsHorizontalScrollIndicator]");
    // trace("*[* *load*]");
    //文件解密类：jpg/webp/ts/m3u8
    //LOG("Tracing "+ target.name +" "+ target.address, { c: Color.Gray });
    // Tracing +[AESUtils decryptFile:sourceFile:destFile:] -[IJKFFMoviePlayerController setHudUrl:] address: 0x102b73954
    // traceAESUtils("","+[AESUtils baseEncrypt:sourceFile:destFile:]");

    // functionName为要hook的函数名

    //console.log("加载的具体模块："+Process.enumerateModules());
    // Process.enumerateModules({
    //     onMatch: function(module) {
    //         console.log(
    //             "Module name:", module.name,
    //             "\nBase address:", module.base.toString(),
    //             "\nSize:", module.size.toString()
    //         );
    //     },
    //     onComplete: function() {}
    // });
    // });
    /*
        var sub_10060f0a4 = getExportFunction("f", "sub_10060f0a4", "int", ["int", "int", "int"]);
    
        Interceptor.attach(sub_10060f0a4, {
            onEnter: function(args) {
                console.log("sub_10060f0a4 called with arguments:", args[0].toInt32(), args[1].toInt32(), args[2].toInt32());
            },
            onLeave: function(retval) {
                console.log("sub_10060f0a4 returned:", retval.toInt32());
            }
    
        var functionName = "av_aes_init";
        Interceptor.attach(Module.findExportByName(null, functionName), {
            onEnter: function(args) {
                // 输出函数调用参数
                // console.log("[*] " + functionName + " called with key: " + args[1] + ", iv: " + args[2]);
                console.log("[*] " + functionName + " called with key: ");
                // 修改第一个参数（key）
                // var newKey = [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x00];
                // Memory.writeByteArray(args[1], newKey, newKey.length);
            },
            onLeave: function(retval) {
                // 输出返回值
                console.log("[*] " + functionName + " returned with value: " + retval);
            }
        });
        */

    // trace("*[IJKFFMoviePlayerController initWithContentURLString*]");


    /**
    {
        key = "TwtsEgjErnXRwOo1ofUQ2g==";
        title = "JUFE-404 \U7206\U4e73\U30ad\U30e1\U30bb\U30af\U6f6e\U5439\U304d\U7d76\U9802 \U5f7c\U6c0f\U304c\U5c45\U308b\U3059\U3050\U96a3\U3067\U6574\U9ad4\U5e2b\U306b\U5be2\U53d6\U3089\U308c\U3066\U2026 \U6843\U5712\U6190\U5948";
        url = "cache2:http://127.0.0.1:8283/fx2ddip00vvb/fx2ddip00vvb.m3u8";
        waterMark = "";
    }
     */
    // trace("*[IJKPlayer *]");


    /*
        var IJKFFMoviePlayerController = ObjC.classes.IJKFFMoviePlayerController;
        Interceptor.attach(
            IJKFFMoviePlayerController['- setHudUrl:'].implementation, 
            {
              onEnter: function (args) {
                // 获取第一个参数（即 URL 对象）
                var urlObj = new ObjC.Object(args[2]);      
                console.log('[*] Original Hud URL:', urlObj);
                // 创建新的 URL 对象，并替换第一个参数
                var newUrlObj =  nsstr('https://video.dcgvc.com/video/m3u8/2023/03/27/6df8ee4e/diba.ts');
                args[2] =newUrlObj;
                
              },
              onLeave: function(retval) {
                // 打印返回值
                printArg("retval: ", retval);
                // console.log("[*] Return value:", retval);
              }
            }
          );
     */

} else {
    LOG("error: Objective-C Runtime is not available!");
}
// ---------------------------------------------------------------




function base64encode(str) {
	var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var out, i, len;
    var c1, c2, c3;

    len = str.length;
    i = 0;
    out = "";
    while (i < len) {
        c1 = str.charCodeAt(i++) & 0xff;
        if (i == len) {
            out += base64EncodeChars.charAt(c1 >> 2);
            out += base64EncodeChars.charAt((c1 & 0x3) << 4);
            out += "==";
            break;
        }
        c2 = str.charCodeAt(i++);
        if (i == len) {
            out += base64EncodeChars.charAt(c1 >> 2);
            out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
            out += base64EncodeChars.charAt((c2 & 0xF) << 2);
            out += "=";
            break;
        }
        c3 = str.charCodeAt(i++);
        out += base64EncodeChars.charAt(c1 >> 2);
        out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
        out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
        out += base64EncodeChars.charAt(c3 & 0x3F);
    }
    return out;
}

function bin2string(array){
	var result = "";
	for(var i = 0; i < array.length; ++i){
		result+= (String.fromCharCode(array[i]));
	}
	return result;
}

function bin2string16(array){
	var result = "";
	for(var i = 0; i < 16; ++i){
		result+= (String.fromCharCode(array[i]));
	}
	return result;
}

Interceptor.attach(Module.findExportByName('libcommonCrypto.dylib', 'CCCrypt__TEST'), {
    onEnter: function (args) {
        // Save the arguments
        this.operation   = args[0]
        this.CCAlgorithm = args[1]
        this.CCOptions   = args[2]
        this.keyBytes    = args[3]
        this.keyLength   = args[4]
        this.ivBuffer    = args[5]
        this.inBuffer    = args[6]
        this.inLength    = args[7]
        this.outBuffer   = args[8]
        this.outLength   = args[9]
        this.outCountPtr = args[10]
        console.log("[+] --------------------------------------------------------------");
        // 不要在onLeave回溯堆栈，会产生误报！
        console.log('\tACCURATE Backtrace:\n\t' + Thread.backtrace(this.context,Backtracer.ACCURATE).map(DebugSymbol.fromAddress).join('\n\t'));
        // console.log('\tFUZZY Backtrace:\n\t' + Thread.backtrace(this.context,Backtracer.FUZZY).map(DebugSymbol.fromAddress).join('\n\t'));

    },

    onLeave: function (retVal) {
        if (this.operation == 0) {
             // Show the buffers here if this an encryption operation

            // console.log("[+] CCAlgorithm: " + this.CCAlgorithm);
            if (this.CCAlgorithm == 0x0) {console.log("[+] CCAlgorithm: " + this.CCAlgorithm + " --> AES Encrypt");}
            if (this.CCAlgorithm == 0x1) {console.log("[+] CCAlgorithm: " + this.CCAlgorithm + " --> DES Encrypt");}
            if (this.CCAlgorithm == 0x2) {console.log("[+] CCAlgorithm: " + this.CCAlgorithm + " --> 3DES Encrypt");}


            // enum {
            //     /* options for block ciphers */
            //     kCCOptionPKCS7Padding   = 0x0001,
            //     kCCOptionECBMode        = 0x0002
            //     /* stream ciphers currently have no options */
            // };
            // typedef uint32_t CCOptions;
            if (this.CCOptions == 0x0 || this.CCOptions == 0x1) {console.log("[+] CCOptions: " + this.CCOptions + " --> mode CBC");}
            if (this.CCOptions == 0x2 || this.CCOptions == 0x3) {console.log("[+] CCOptions: " + this.CCOptions + " --> mode ECB");} // kCCOptionPKCS7Padding | kCCOptionECBMode == 0x03
            // if (this.CCOptions != 0x1 && this.CCOptions != 0x3) {console.log("[+] CCOptions: " + this.CCOptions);}

            console.log(Memory.readByteArray(this.inBuffer, this.inLength.toInt32()));
            try {
                // console.log("[+] Before Encrypt: " + Memory.readUtf8String(this.inBuffer, this.inLength.toInt32()));
                LOG("[+] Before Encrypt: " + Memory.readUtf8String(this.inBuffer, this.inLength.toInt32()), { c: Color.Gray }); 

            } catch(e) {
                // var ByteArray = Memory.readByteArray(this.inBuffer, this.inLength.toInt32());
                // var uint8Array = new Uint8Array(ByteArray);
                // // console.log("[+] uint8Array: " + uint8Array);

                // var str = "";
                // for(var i = 0; i < uint8Array.length; i++) {
                //     var hextemp = (uint8Array[i].toString(16))
                //     if(hextemp.length == 1){
                //         hextemp = "0" + hextemp
                //     }
                //         str += hextemp + " ";
                // }

                // console.log("[+] Before Encrypt: " + str); // 打印hex,非可见ascii范围
            }  
            
            console.log(Memory.readByteArray(this.keyBytes, this.keyLength.toInt32()));
            

            if (this.keyLength.toInt32() == 16) {console.log("[+] KEY Length --> 128");}
            if (this.keyLength.toInt32() == 24) {console.log("[+] KEY Length --> 192");}
            if (this.keyLength.toInt32() == 32) {console.log("[+] KEY Length --> 256");}
            try {
                // console.log("[+] KEY: " + Memory.readUtf8String(this.keyBytes, this.keyLength.toInt32()));
                LOG("[+] KEY: " + Memory.readUtf8String(this.keyBytes, this.keyLength.toInt32()), { c: Color.Gray }); 
            } catch(e) {
                var ByteArray = Memory.readByteArray(this.keyBytes, this.keyLength.toInt32());
                var uint8Array = new Uint8Array(ByteArray);
                // console.log("[+] uint8Array: " + uint8Array);

                var str = "";
                for(var i = 0; i < uint8Array.length; i++) {
                    var hextemp = (uint8Array[i].toString(16))
                    if(hextemp.length == 1){
                        hextemp = "0" + hextemp
                    }
                        str += hextemp + " ";
                }

                // console.log("[+] KEY: " + str); // 打印hex,非可见ascii范围
                LOG("[+] KEY: " + str, { c: Color.Gray }); 
            }     

            if (this.CCOptions == 0x0 || this.CCOptions == 0x1) {
                console.log(Memory.readByteArray(this.ivBuffer, 16));
                try {
                    // console.log("[+] IV: " + Memory.readUtf8String(this.ivBuffer, this.keyLength.toInt32()));
                    var bytes = Memory.readUtf8String(this.ivBuffer, 16);
                    LOG("[+] IV: " + bytes, { c: Color.Gray });  
                    // 对数据进行 Base64 编码
                    // var base64Str = base64Encode(bytes);

                    // console.log("[+] IV Base64: " + base64Str);

                } catch(e) {
                    var ByteArray = Memory.readByteArray(this.ivBuffer, 16);
                    var uint8Array = new Uint8Array(ByteArray);

                    var str = "";
                    for(var i = 0; i < uint8Array.length; i++) {
                        var hextemp = (uint8Array[i].toString(16))
                        if(hextemp.length == 1){
                            hextemp = "0" + hextemp
                        }
                        str += hextemp + " ";
                    }

                    // console.log("[+] IV: " + str); // 打印hex,非可见ascii范围
                    LOG("[+] IV: " + str, { c: Color.Gray }); 
                }
            }
             
            // console.log(Memory.readByteArray(this.outBuffer, Memory.readUInt(this.outCountPtr))); // 打印hex,非可见ascii范围
            var array = new Uint8Array(Memory.readByteArray(this.outBuffer, Memory.readUInt(this.outCountPtr)));
            LOG("[+] After Encrypt: " + base64encode(bin2string(array)), { c: Color.Gray });
            // console.log("[+] After Encrypt: " + base64encode(bin2string(array)));
            

            console.log("[-] --------------------------------------------------------------\n");
        }

        if (this.operation == 1) {
            // Show the buffers here if this a decryption operation

            // console.log("inLength: " + this.inLength.toInt32());
            // console.log("outLength: " + this.outLength.toInt32());
            // console.log("outCount: " + Memory.readUInt(this.outCountPtr)); //实际的outBuffer的有效长度

            // console.log("[+] CCAlgorithm: " + this.CCAlgorithm);
            if (this.CCAlgorithm == 0x0) {console.log("[+] CCAlgorithm: " + this.CCAlgorithm + " --> AES Decrypt");}
            if (this.CCAlgorithm == 0x1) {console.log("[+] CCAlgorithm: " + this.CCAlgorithm + " --> DES Decrypt");}
            if (this.CCAlgorithm == 0x2) {console.log("[+] CCAlgorithm: " + this.CCAlgorithm + " --> 3DES Decrypt");}

            // enum {
            //     /* options for block ciphers */
            //     kCCOptionPKCS7Padding   = 0x0001,
            //     kCCOptionECBMode        = 0x0002
            //     /* stream ciphers currently have no options */
            // };
            // typedef uint32_t CCOptions;
            if (this.CCOptions == 0x0 || this.CCOptions == 0x1) {console.log("[+] CCOptions: " + this.CCOptions + " --> mode CBC");}
            if (this.CCOptions == 0x2 || this.CCOptions == 0x3) {console.log("[+] CCOptions: " + this.CCOptions + " --> mode ECB");} // kCCOptionPKCS7Padding | kCCOptionECBMode == 0x03
            // if (this.CCOptions != 0x1 && this.CCOptions != 0x3) {console.log("[+] CCOptions: " + this.CCOptions);}

            var array = new Uint8Array(Memory.readByteArray(this.inBuffer, this.inLength.toInt32()));
            console.log("[+] Before Decrypt: " + base64encode(bin2string(array)));
            // LOG("[+] Before Decrypt: " + base64encode(bin2string(array)), { c: Color.Gray }); 
            LOG("[+] Before Decrypt: 数据过大，忽略 ", { c: Color.Gray }); 
            
            LOG("[+] key 二进制: ");
            console.log(Memory.readByteArray(this.keyBytes, this.keyLength.toInt32()));

            var arraykey = new Uint8Array(Memory.readByteArray(this.keyBytes, Memory.readUInt(this.outCountPtr)));
            // LOG("[+] key Base64后: " + base64encode(bin2string(arraykey)), { c: Color.Yellow });
            LOG("[+] key Base64后: " + base64encode(bin2string16(arraykey)), { c: Color.Yellow });

            // LOG("[+ Base64] KEY: " + base64encode(Memory.readByteArray(this.keyBytes, this.keyLength.toInt32())) , { c: Color.Yellow })//
            if (this.keyLength.toInt32() == 16) {console.log("[+] KEY Length --> 128");}
            if (this.keyLength.toInt32() == 24) {console.log("[+] KEY Length --> 192");}
            if (this.keyLength.toInt32() == 32) {console.log("[+] KEY Length --> 256");}
            try {
                // console.log("[+] KEY: " + Memory.readUtf8String(this.keyBytes, this.keyLength.toInt32()));
                LOG("[+] KEY: " + Memory.readUtf8String(this.keyBytes, this.keyLength.toInt32()), { c: Color.Gray }); 
                
            } catch(e) {
                var ByteArray = Memory.readByteArray(this.keyBytes, this.keyLength.toInt32());
                var uint8Array = new Uint8Array(ByteArray);
                // console.log("[+] uint8Array: " + uint8Array);

                var str = "";
                for(var i = 0; i < uint8Array.length; i++) {
                    var hextemp = (uint8Array[i].toString(16))
                    if(hextemp.length == 1){
                        hextemp = "0" + hextemp
                    }
                    str += hextemp + " ";
                }

                // console.log("[+] KEY: " + str); // 打印hex,非可见ascii范围
                LOG("Error [+] KEY: " + str, { c: Color.Gray }); 
                

            }     

            if (this.CCOptions == 0x0 || this.CCOptions == 0x1) {

                LOG("[+] IV 二进制: ");

                var erjinzhi = Memory.readByteArray(this.ivBuffer, 16);
                console.log(erjinzhi);

                var arrayIV = new Uint8Array(erjinzhi);
                LOG("[+] IV Base64后: " + base64encode(bin2string(arrayIV)), { c: Color.Yellow });
                

                // LOG("[+ Base64] IV: " + base64encode(erjinzhi) , { c: Color.Yellow })//
                
                // console.log(hexdump(erjinzhi, {
                //   offset: 0,
                //   length: 64,
                //   header: true,
                //   ansi: true
                // }));

                try {
                    // console.log("[+] IV: " + Memory.readUtf8String(this.ivBuffer, this.keyLength.toInt32()));
                    LOG("[+] IV: " + Memory.readUtf8String(this.ivBuffer, 16), { c: Color.Gray }); 

                    var erjinzhi = Memory.readByteArray(this.ivBuffer, 16);
                    console.log(erjinzhi);

                    var arrayIV = new Uint8Array(erjinzhi);
                    LOG("[+] IV Base64后: " + base64encode(bin2string(arrayIV)), { c: Color.Yellow });
                    
                } catch(e) {
                    var ByteArray = Memory.readByteArray(this.ivBuffer, 16);
                    var uint8Array = new Uint8Array(ByteArray);

                    var str = "";
                    for(var i = 0; i < uint8Array.length; i++) {
                        var hextemp = (uint8Array[i].toString(16))
                        if(hextemp.length == 1){
                            hextemp = "0" + hextemp
                        }
                        str += hextemp + " ";
                    }

                    // console.log("[+] IV: " + str); // 打印hex,非可见ascii范围
                    LOG("Error [+] IV: " + str, { c: Color.Gray }); 
                }
            }

            //console.log(Memory.readByteArray(this.outBuffer, Memory.readUInt(this.outCountPtr)));
            try {
               // console.log("[+] After Decrypt: " + Memory.readUtf8String(this.outBuffer, Memory.readUInt(this.outCountPtr)));
               LOG("[+] After Decrypt: " + Memory.readUtf8String(this.outBuffer, Memory.readUInt(this.outCountPtr)), { c: Color.Gray });
            } catch(e) {
                // var ByteArray = Memory.readByteArray(this.outBuffer, Memory.readUInt(this.outCountPtr));
                // var uint8Array = new Uint8Array(ByteArray);
                // // console.log("[+] uint8Array: " + uint8Array);

                // var str = "";
                // for(var i = 0; i < uint8Array.length; i++) {
                //     var hextemp = (uint8Array[i].toString(16))
                //     if(hextemp.length == 1){
                //         hextemp = "0" + hextemp
                //     }
                //         str += hextemp + " ";
                // }

                // console.log("[+] After Decrypt: " + str); // 打印hex,非可见ascii范围
            }


            

            console.log("[-] --------------------------------------------------------------\n");
        }
    }
})
