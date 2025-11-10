//  5 Arrow Function And This Value
/* Main lessons functions :
    1- [This] Reference value in the Regular function  
    2- {This} usage and attidute within in the Regular function { Auto counter application upon [this] value }
    3- {This} usage and attidute within in the Arrow function { Auto counter application upon [this] value }
*/
// ---------------------------------------------------------------------

// 5 Arrow Function And [This] operator  :
function myTest() {
    'use strict' ;
    alert('Welcome to 5 Arrow Function And This Value ') ;
    
    var dis = document.getElementById('note');
     
    var x = prompt(' Please choose one of functions from below options : \n  1] [This] Reference value in the Regular function \n  2] {This} Reference value in the Arrow function  \n  3] {This} attidute value in the both {Arrow function} & {Regular Function }  ');    

    if (x == 1 ) {
        
        regFuncValue();

    } else if (x == 2) {
    
        regFuncThis();
        
    } else if (x == 3) {
    
        arrowFuncThis();       
    
    // } else if (x == 4) {

    //     arrowShortFunc2();
    
    // } else if (x == 5) {

    //     arrowShortFunc3();

    } else {
        alert('No option has been selected !');
    } 

    // =========================================================================

    // 1] Test and print [This] Reference value in the Regular function :
    function regFuncValue() {
        alert('Welcome to Test and print [This] Reference value in the Regular function  ');

        dis.innerHTML = '';


        // Assigning the element innerHTML by the value of it's caller funtion :
        let regFuncVal1 = function() {
            document.getElementById('note').innerHTML = this;
        }
        
        // Executing the [this] 's refers value within {Regular function} by using built-in {window} object  & {onload} event :
        window.onload = regFuncVal1;
        
        // ---------------------------------------
        
        // Executing the [this] 's refers value within {Regular function} by using built-in {button} object  & {addEventLister} event  :
        document.getElementById('elem').addEventListener( 'click' , regFuncVal1);         
        // ---------------------------------------
        
        // console.log('Regular Function of calling function by using [this] operator : ' , regFuncVal1() ) ;
        console.log('Regular Function Syntax by using Default method : '  ,  regFuncVal1 ) ;
        
        dis.innerHTML = 'Regular Function Syntax by using Default method : ' +  regFuncVal1 + '<br>' ;

        // ------------------------

    }
    // =============================================================

    // 2] {This} usages and attidute value within the [Regular function] => { Auto counter application upon [this] value }:
    function regFuncThis() {
        alert('Welcome to Test and print {this} usages and attidute value within the [Regular function] ');

        dis.innerHTML = '';

        let regFuncThisApp = function () {
            let that = this;
            this.age = 0;

            setInterval( function(){
                that.age++ ;
                console.log(that.age);
            }, 1000 );

            // Executing the current fuction by Extracting new object form the constrcutor function : 
            let user = new regFuncThisApp();   
        }

       
        // console.log('Regular Function : ' , regFuncThisApp() ) ;
        console.log('Regular Function Syntax by using this solution Method [assigning (this) to another variable ] : '  , regFuncThisApp ) ;
       
        dis.innerHTML += 'Regular Function Syntax by using this solution Method [assigning (this) to another variable ] : ' + regFuncThisApp + '<br>' ;
        
    }
    // =========================================================
    
    // 3] {This} usages and Attidute value within the [Arrow function] => { Auto counter application upon [this] value }:
    function arrowFuncThis() {
        alert('Welcome to Test and print {this} usages and attidute value within the [Arrow function] ');

        dis.innerHTML = '';

        let arrowFuncThisApp = function()  {
         
            this.age = 0;

            setInterval( () => {
                this.age++ ;
                console.log(this.age);
            }, 1000 );
        
            // Executing the current fuction by Extracting new object form the constrcutor function : 
            let user = new arrowFuncThisApp();
        }
    
        // console.log('Regular Function : ' , regFuncThisApp() ) ;
        console.log('Arrow Function Syntax by using directly [this] Method : '  , arrowFuncThisApp ) ;
       
        dis.innerHTML += 'Arrow Function Syntax by using directly [this] Method : '  + arrowFuncThisApp + '<br>' ;
        
    }
    // =========================================================

   //===========================================================
    
    function display() {
        document.getElementById("note").innerHTML = myTest + "\n\n" + "=".repeat(90) + "\n\n";
    }

}