//
//  TFHppleElement+InnerContent.m
//  Hpple
//
//  Created by Jon Lidgard on 14/04/2013.
//
//

#import "TFHppleElement+InnerContent.h"

NSString *const TFHppleOptionsNoTags = @"noTags";

@implementation TFHppleElement (InnerContent)

- (NSString *)innerHTML {
    return [self processChildren:self options:nil];
}

- (NSString *)innerText {
    return [self processChildren:self options:[NSDictionary dictionaryWithObject:@"YES" forKey:TFHppleOptionsNoTags]];
}

- (NSString*)openingTagForElement:(TFHppleElement*)element {
    return [NSString stringWithFormat:@"<%@%@>",[element tagName], [self attributesStringForElement:element]];
}

- (NSString*)closingTag:(NSString*)tag {
    return [NSString stringWithFormat:@"</%@>",tag];
}

- (NSString*)attributesStringForElement:(TFHppleElement*)element {
    NSDictionary *attributes = [element attributes];
    NSMutableString *attrString = [[NSMutableString alloc] init];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [attrString appendFormat:@" \"%@\"=\"%@\"",key,obj];
    }];
    return attrString;
}

- (NSString*)processChildren:(TFHppleElement *)element options:(NSDictionary*)options  {

    BOOL noTags = ([options objectForKey:TFHppleOptionsNoTags] != nil);
    NSString *openingTag = noTags ? @"" : [self openingTagForElement:element];
    NSMutableString *content = [[NSMutableString alloc] initWithString:openingTag];
    
    for (TFHppleElement *nextChild in [element children]) {
        NSString *appendedContent = [nextChild content];
        if (appendedContent) {
            [content appendString:appendedContent];
        }
        if ([nextChild hasChildren]) {
            [content appendString:[self processChildren:nextChild options:options]];
        }
    }
    NSString *closingTag = noTags ? @"" : [self closingTag:[element tagName]];
    [content appendString:closingTag];
    return content;
}


@end
