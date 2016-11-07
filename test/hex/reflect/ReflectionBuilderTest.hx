package hex.reflect;

import hex.reflect.ClassReflectionDataProvider;
import hex.reflect.IClassReflectionDataProvider;
import hex.reflect.mock.IMockAnnotationContainer;
import hex.reflect.mock.MockAnnotationContainer;
import hex.reflect.mock.MockContainerWithoutAnnotation;
import hex.reflect.mock.MockExtendedAnnotationContainer;
import hex.domain.Domain;
import hex.log.ILogger;
import hex.log.Logger;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ReflectionBuilderTest
{
    static var _annotationProvider : IClassReflectionDataProvider;

    @BeforeClass
    public static function beforeClass() : Void
    {
        ReflectionBuilderTest._annotationProvider = new ClassReflectionDataProvider( IMockAnnotationContainer );
    }

    @AfterClass
    public static function afterClass() : Void
    {
        ReflectionBuilderTest._annotationProvider = null;
    }

    @Test( "test get annotation data with class name" )
    public function testGetAnnotationDataWithClassName() : Void
    {
        Assert.isNotNull( ReflectionBuilderTest._annotationProvider, "annotation data map shouldn't be null" );
        Assert.isNotNull( ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockAnnotationContainer ), "'MockAnnotationContainer' class should be referenced" );
        Assert.isNotNull( ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockExtendedAnnotationContainer ), "'MockExtendedAnnotationContainer' class should be referenced" );

        var data0 = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockAnnotationContainer );
        Assert.equals( Type.getClassName( MockContainerWithoutAnnotation ), data0.superClassName, "superClass name should be the same" );

        var data1 = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockExtendedAnnotationContainer );
        Assert.equals( Type.getClassName( MockAnnotationContainer ), data1.superClassName, "superClass name should be the same" );
    }

    @Test( "test get annotation data from constructor" )
    public function testGetAnnotationDataFromConstructor() : Void
    {
        var data = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockAnnotationContainer );
        Assert.isNotNull( data.constructor, "constructor annotation data shouldn't be null" );
        Assert.equals( "new", data.constructor.methodName, "constructor 'methodName' should be 'new'" );

        Assert.equals( 2, data.constructor.arguments.length, "argument length should be 2" );
        var arg0 = data.constructor.arguments[ 0 ];
        Assert.equals( "domain", arg0.argumentName, "argument name should be the same" );
        Assert.equals( Type.getClassName( Domain ), arg0.argumentType, "argument type should be the same" );

        var arg1 = data.constructor.arguments[ 1 ];
        Assert.equals( "logger", arg1.argumentName, "argument name should be the same" );
        Assert.equals( Type.getClassName( ILogger ), arg1.argumentType, "argument type should be the same" );

        Assert.equals( 1, data.constructor.annotations.length, "annotation length should be 1" );
        var annotationData = data.constructor.annotations[ 0 ];
        Assert.equals( "Inject", annotationData.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["a", 2, true], annotationData.annotationKeys, "annotation keys should be the same" );
    }

    @Test( "test get annotation data from properties" )
    public function testGetAnnotationDataFromProperties() : Void
    {
        var data = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockAnnotationContainer );
        Assert.equals( 2, data.properties.length, "properties length should be 2" );

        var property0 = data.properties[ 0 ];
        Assert.equals( "property", property0.propertyName, "property name should be the same" );
        Assert.equals( Type.getClassName( Logger ), property0.propertyType, "property type should be the same" );

        Assert.equals( 2, property0.annotations.length, "annotation length should be 2" );
        var annotationData0 = property0.annotations[ 0 ];
        Assert.equals( "Inject", annotationData0.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["ID", "name", 3], annotationData0.annotationKeys, "annotation keys should be the same" );
        var annotationData1 = property0.annotations[ 1 ];
        Assert.equals( "Language", annotationData1.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["fr"], annotationData1.annotationKeys, "annotation keys should be the same" );

        var property1 = data.properties[ 1 ];
        Assert.equals( "_privateProperty", property1.propertyName, "property name should be the same" );
        Assert.equals( "Int", property1.propertyType, "property type should be the same" );


        Assert.equals( 2, property1.annotations.length, "annotation length should be 2" );
        var annotationData2 = property1.annotations[ 0 ];
        Assert.equals( "Inject", annotationData2.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["b", 3, false], annotationData2.annotationKeys, "annotation keys should be the same" );
        var annotationData3 = property1.annotations[ 1 ];
        Assert.equals( "Language", annotationData3.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["en"], annotationData3.annotationKeys, "annotation keys should be the same" );
    }

    @Test( "test get annotation data from methods" )
    public function testGetAnnotationDataFromMethods() : Void
    {
        var data = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockAnnotationContainer );
        Assert.equals( 2, data.methods.length, "methods length should be 3" );

        var method0 = data.methods[ 0 ];
        Assert.equals( "testMethodWithPrim", method0.methodName, "method name should be the same" );
        Assert.equals( 5, method0.arguments.length, "argument length should be 5" );
        Assert.equals( method0.arguments[ 0 ].argumentName, "i", "argument data should be the same" );
        Assert.equals( method0.arguments[ 0 ].argumentType, "Int", "argument data should be the same" );
        Assert.equals( method0.arguments[ 1 ].argumentName, "u", "argument data should be the same" );
        Assert.equals( method0.arguments[ 1 ].argumentType, "UInt", "argument data should be the same" );
        Assert.equals( method0.arguments[ 2 ].argumentName, "b", "argument data should be the same" );
        Assert.equals( method0.arguments[ 2 ].argumentType, "Bool", "argument data should be the same" );
        Assert.equals( method0.arguments[ 3 ].argumentName, "s", "argument data should be the same" );
        Assert.equals( method0.arguments[ 3 ].argumentType, "String", "argument data should be the same" );
        Assert.equals( method0.arguments[ 4 ].argumentName, "f", "argument data should be the same" );
        Assert.equals( method0.arguments[ 4 ].argumentType, "Float", "argument data should be the same" );

        Assert.equals( 2, method0.annotations.length, "annotation length should be 2" );
        var annotationData0 = method0.annotations[ 0 ];
        Assert.equals( "Test", annotationData0.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["testMethodWithPrimMetadata"], annotationData0.annotationKeys, "annotation keys should be the same" );
        var annotationData1 = method0.annotations[ 1 ];
        Assert.equals( "PostConstruct", annotationData1.annotationName, "annotation name should be the same" );
        Assert.equals( 0, annotationData1.annotationKeys[ 0 ], "annotation keys should be the same" );

        var method1 = data.methods[ 1 ];
        Assert.equals( "_methodToOverride", method1.methodName, "method name should be the same" );
        Assert.equals( 1, method1.arguments.length, "argument length should be 1" );
        Assert.equals( method1.arguments[ 0 ].argumentName, "element", "argument data should be the same" );
        Assert.equals( method1.arguments[ 0 ].argumentType, "hex.log.Logger", "argument data should be the same" );

        Assert.equals( 3, method1.annotations.length, "annotation length should be 3" );
        var annotationData0 = method1.annotations[ 0 ];
        Assert.equals( "Test", annotationData0.annotationName, "annotation name should be the same" );
        Assert.equals( "methodToOverrideMetadata", annotationData0.annotationKeys[ 0 ], "annotation keys should be the same" );
        var annotationData1 = method1.annotations[ 1 ];
        Assert.equals( "PostConstruct", annotationData1.annotationName, "annotation name should be the same" );
        Assert.equals( 1, annotationData1.annotationKeys[ 0 ], "annotation keys should be the same" );
        var annotationData2 = method1.annotations[ 2 ];
        Assert.equals( "Optional", annotationData2.annotationName, "annotation name should be the same" );
        Assert.equals( true, annotationData2.annotationKeys[ 0 ], "annotation keys should be the same" );
    }

    @Test( "test get annotation data from extended constructor" )
    public function testGetAnnotationDataFromExtendedConstructor() : Void
    {
        var data : ClassReflectionData = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockExtendedAnnotationContainer );
        Assert.isNotNull( data.constructor, "constructor annotation data shouldn't be null" );
        Assert.equals( "new", data.constructor.methodName, "constructor 'methodName' should be 'new'" );

        Assert.equals( 3, data.constructor.arguments.length, "argument length should be 3" );

        var arg0 = data.constructor.arguments[ 0 ];
        Assert.equals( "a", arg0.argumentName, "argument name should be the same" );
        Assert.equals( Type.getClassName( Array ), arg0.argumentType, "argument type should be the same" );

        var arg1 = data.constructor.arguments[ 1 ];
        Assert.equals( "extendedDomain", arg1.argumentName, "argument name should be the same" );
        Assert.equals( Type.getClassName( Domain ), arg1.argumentType, "argument type should be the same" );

        var arg2 = data.constructor.arguments[ 2 ];
        Assert.equals( "extendedLogger", arg2.argumentName, "argument name should be the same" );
        Assert.equals( Type.getClassName( ILogger ), arg2.argumentType, "argument type should be the same" );

        Assert.equals( 2, data.constructor.annotations.length, "annotation length should be 2" );
        var annotationData0 = data.constructor.annotations[ 0 ];
        Assert.equals( "Inject", annotationData0.annotationName, "annotation name should be the same" );
        Assert.deepEquals( [ "d", 3, false ], annotationData0.annotationKeys, "annotation keys should be the same" );
        var annotationData1 = data.constructor.annotations[ 1 ];
        Assert.equals( "ConstructID", annotationData1.annotationName, "annotation name should be the same" );
        Assert.equals( 9, annotationData1.annotationKeys[ 0 ], "annotation keys should be the same" );
    }

    @Test( "test get annotation data from extended properties" )
    public function testGetAnnotationDataFromExtendedProperties() : Void
    {
        var data : ClassReflectionData = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockExtendedAnnotationContainer );
        Assert.equals( 3, data.properties.length, "properties length should be 3" );

        var property0 = data.properties[ 0 ];
        Assert.equals( "property", property0.propertyName, "property name should be the same" );
        Assert.equals( Type.getClassName( Logger ), property0.propertyType, "property type should be the same" );

        Assert.equals( 2, property0.annotations.length, "annotation length should be 2" );
        var annotationData0 = property0.annotations[ 0 ];
        Assert.equals( "Inject", annotationData0.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["ID", "name", 3], annotationData0.annotationKeys, "annotation keys should be the same" );
        var annotationData1 = property0.annotations[ 1 ];
        Assert.equals( "Language", annotationData1.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["fr"], annotationData1.annotationKeys, "annotation keys should be the same" );

        var property1 = data.properties[ 1 ];
        Assert.equals( "_privateProperty", property1.propertyName, "property name should be the same" );
        Assert.equals( "Int", property1.propertyType, "property type should be the same" );

        Assert.equals( 2, property1.annotations.length, "annotation length should be 2" );
        var annotationData2 = property1.annotations[ 0 ];
        Assert.equals( "Inject", annotationData2.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["b", 3, false], annotationData2.annotationKeys, "annotation keys should be the same" );
        var annotationData3 = property1.annotations[ 1 ];
        Assert.equals( "Language", annotationData3.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["en"], annotationData3.annotationKeys, "annotation keys should be the same" );

        var property2 = data.properties[ 2 ];
        Assert.equals( "anotherProperty", property2.propertyName, "property name should be the same" );
        Assert.equals( "Bool", property2.propertyType, "property type should be the same" );

        Assert.equals( 2, property2.annotations.length, "annotation length should be 2" );
        var annotationData3 = property2.annotations[ 0 ];
        Assert.equals( "Inject", annotationData2.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["anotherID", "anotherName", 3], annotationData3.annotationKeys, "annotation keys should be the same" );
        var annotationData4 = property2.annotations[ 1 ];
        Assert.equals( "Language", annotationData4.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["it"], annotationData4.annotationKeys, "annotation keys should be the same" );

    }

    @Test( "test get annotation data from extended methods" )
    public function testGetAnnotationDataFromExtendedMethods() : Void
    {
        var data : ClassReflectionData = ReflectionBuilderTest._annotationProvider.getClassReflectionData( MockExtendedAnnotationContainer );
        Assert.equals( 3, data.methods.length, "methods length should be 3" );

        var method0 = data.methods[ 0 ];
        Assert.equals( "testMethodWithPrim", method0.methodName, "method name should be the same" );
        Assert.equals( 5, method0.arguments.length, "argument length should be 5" );
        Assert.equals( method0.arguments[ 0 ].argumentName, "i", "argument data should be the same" );
        Assert.equals( method0.arguments[ 0 ].argumentType, "Int", "argument data should be the same" );
        Assert.equals( method0.arguments[ 1 ].argumentName, "u", "argument data should be the same" );
        Assert.equals( method0.arguments[ 1 ].argumentType, "UInt", "argument data should be the same" );
        Assert.equals( method0.arguments[ 2 ].argumentName, "b", "argument data should be the same" );
        Assert.equals( method0.arguments[ 2 ].argumentType, "Bool", "argument data should be the same" );
        Assert.equals( method0.arguments[ 3 ].argumentName, "s", "argument data should be the same" );
        Assert.equals( method0.arguments[ 3 ].argumentType, "String", "argument data should be the same" );
        Assert.equals( method0.arguments[ 4 ].argumentName, "f", "argument data should be the same" );
        Assert.equals( method0.arguments[ 4 ].argumentType, "Float", "argument data should be the same" );

        Assert.equals( 2, method0.annotations.length, "annotation length should be 2" );
        var annotationData0 = method0.annotations[ 0 ];
        Assert.equals( "Test", annotationData0.annotationName, "annotation name should be the same" );
        Assert.deepEquals( ["testMethodWithPrimMetadata"], annotationData0.annotationKeys, "annotation keys should be the same" );
        var annotationData1 = method0.annotations[ 1 ];
        Assert.equals( "PostConstruct", annotationData1.annotationName, "annotation name should be the same" );
        Assert.equals( 0, annotationData1.annotationKeys[ 0 ], "annotation keys should be the same" );

        var method1 = data.methods[ 1 ];
        Assert.equals( "_methodToOverride", method1.methodName, "method name should be the same" );
        Assert.equals( 1, method1.arguments.length, "argument length should be 1" );
        Assert.equals( method1.arguments[ 0 ].argumentName, "element", "argument data should be the same" );
        Assert.equals( method1.arguments[ 0 ].argumentType, "hex.log.Logger", "argument data should be the same" );

        Assert.equals( 3, method1.annotations.length, "annotation length should be 3" );
        var annotationData0 = method1.annotations[ 0 ];
        Assert.equals( "Test", annotationData0.annotationName, "annotation name should be the same" );
        Assert.equals( "methodToOverrideMetadata", annotationData0.annotationKeys[ 0 ], "annotation keys should be the same" );
        var annotationData1 = method1.annotations[ 1 ];
        Assert.equals( "PostConstruct", annotationData1.annotationName, "annotation name should be the same" );
        Assert.equals( 3, annotationData1.annotationKeys[ 0 ], "annotation keys should be the same" );
        var annotationData2 = method1.annotations[ 2 ];
        Assert.equals( "Optional", annotationData2.annotationName, "annotation name should be the same" );
        Assert.equals( false, annotationData2.annotationKeys[ 0 ], "annotation keys should be the same" );

        var method2 = data.methods[ 2 ];
        Assert.equals( "anotherTestMethod", method2.methodName, "method name should be the same" );
        Assert.equals( 1, method2.arguments.length, "argument length should be 1" );
        Assert.equals( method2.arguments[ 0 ].argumentName, "f", "argument data should be the same" );
        Assert.equals( method2.arguments[ 0 ].argumentType, "Float", "argument data should be the same" );

        Assert.equals( 2, method2.annotations.length, "annotation length should be 2" );
        var annotationData0 = method2.annotations[ 0 ];
        Assert.equals( "Test", annotationData0.annotationName, "annotation name should be the same" );
        Assert.equals( "anotherTestMethodMetadata", annotationData0.annotationKeys[ 0 ], "annotation keys should be the same" );
        var annotationData1 = method2.annotations[ 1 ];
        Assert.equals( "PostConstruct", annotationData1.annotationName, "annotation name should be the same" );
        Assert.equals( 2, annotationData1.annotationKeys[ 0 ], "annotation keys should be the same" );
    }
}
