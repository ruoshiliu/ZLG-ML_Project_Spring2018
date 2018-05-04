# Using log on submissions and then after exp it, really improves results..
import numpy as np # linear algebra
import pandas as pd
print('b1')
test_files = [

"C:/Users/Public.HYPERION/Downloads/prediction27.csv",
"C:/Users/Public.HYPERION/Downloads/prediction26.csv",
"C:/Users/Public.HYPERION/Downloads/prediction23.csv",
'C:/Users/Public.HYPERION/Downloads/prediction19.csv',
'C:/Users/Public.HYPERION/Downloads/dl_support.csv',
'C:/Users/Public.HYPERION/Downloads/wordbatch_fm_ftrl.csv'
]

ll = []
for test_file in test_files:
    print('read ' + test_file)
    ll.append(pd.read_csv(test_file, encoding='utf-8'))
n_models = len(ll)
pp = n_models
weights = [0.5, 0.25, 0.075, 0.075, 0.025,0.075]
cc = 'is_attributed'
print(np.corrcoef([ll[pp - 4][cc], ll[pp - 3][cc], ll[pp - 2][cc], ll[pp - 1][cc]]))
print('ALWAYS BLEND NON CORRELATED RESULTS TO PREVENT OVERFITTING..')

print('predict')
lll = len(ll[0][cc])
test_predict_column = [0.] * lll
for ind in range(0, n_models):
    test_predict_column += np.log(ll[ind][cc]) * weights[ind]

print('make result')
final_result = ll[0]['click_id']
final_result = pd.concat((final_result, pd.DataFrame(
    {cc: np.exp(test_predict_column)})), axis=1)
final_result.to_csv("blend_1_best4.csv", index=False)

