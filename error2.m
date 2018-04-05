function [percentCorrect,onesPercentCorrect,totalOnes,onesGuessed] = error2(yPTest,yTest)
count2 = 0;
oneCount = 0;
total = size(yTest,1);
totalOnes = sum(yTest(:) == 1);
onesGuessed = sum(yPTest(:) == 1);
for i = 1:total
   if yPTest(i,1) == yTest(i,1)
       if yPTest(i,1) == 1
          oneCount = oneCount + 1; 
       end
      count2 = count2 + 1; 
   end    
end
percentCorrect = count2/total*100;
onesPercentCorrect = oneCount/totalOnes*100;

end

